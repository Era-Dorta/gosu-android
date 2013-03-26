require 'gosu_android/requires'
require 'gosu_android/graphics/graphicsBase'
require 'gosu_android/graphics/color'
require 'gosu_android/graphics/drawOp'
require 'gosu_android/graphics/drawOpQueue'
require 'gosu_android/graphics/image'
require 'gosu_android/graphics/largeImageData'
require 'gosu_android/graphics/bitmapUtils'
require 'gosu_android/graphics/texture'
require 'gosu_android/graphics/font'

module Gosu
  class Graphics
    attr_reader :width, :height
    attr_reader :fullscreen
    attr_reader :gl

    MAX_TEXTURE_SIZE = 1024

    def initialize(android_initializer)
      @android_initializer = android_initializer
    end

    def initialize_window(physical_width, physical_height, fullscreen, window)
      @window = window
      @virt_width = physical_height
      @virt_height = physical_width

      @phys_width = physical_width
      @phys_height = physical_height

      @fullscreen = fullscreen
      #Gl stuff moved to render

      @queues = DrawOpQueue.new(@gl)
      @textures = []
    end

    def set_resolution(virtualWidth, virtualHeight); end

    #Prepares the graphics object for drawing. Nothing must be drawn
    #without calling begin.
    def begin(clear_with_color = Color::BLACK)
      if @gl == nil
        raise "Surface must be created before calling begin"
      end
      @gl.glClearColor(clear_with_color.red / 255.0, clear_with_color.green / 255.0,
        clear_with_color.blue / 255.0, clear_with_color.alpha / 255.0)
      @gl.glClear(JavaImports::GL10::GL_COLOR_BUFFER_BIT | JavaImports::GL10::GL_DEPTH_BUFFER_BIT)

      true
    end
    #Every call to begin must have a matching call to end.
    def end
      flush
      @gl.glFlush
    end
    #Flushes the Z queue to the screen and starts a new one.
    #Useful for games that are *very* composite in nature (splitscreen).
    def flush
      @queues.perform_draw_ops_and_code
      @queues.clear_queue
    end

    #Finishes all pending Gosu drawing operations and executes
    #the following OpenGL code in a clean environment.
    def beginGL; end
    #Resets Gosu o its default rendering state.
    def endGL; end
    #(Experimental)
    #Schedules a custom GL functor to be executed at a certain Z level.
    #The functor is called in a clean GL context (as given by beginGL/endGL).
    #Gosu's rendering up to the Z level may not yet have been glFlush()ed.
    #Note: You may not call any Gosu rendering functions from within the
    #functor, and you must schedule it from within Window::draw's call tree.
    def scheduleGL(functor, z); end

    #Enables clipping to a specified rectangle.
    def begin_clipping(x,  y,  width,  height); end
    #Disables clipping.
    def end_clipping; end

    #Starts recording a macro. Cannot be nested.
    def begin_recording; end
    #Finishes building the macro and returns it as a drawable object.
    #The width and height affect nothing about the recording process,
    #the resulting macro will simply return these values when you ask
    #it.
    #Most usually, the return value is passed to Image::Image().
    def end_recording(width,  height); end

    #Pushes one transformation onto the transformation stack.
    def push_transform(transform); end
    #Pops one transformation from the transformation stack.
    def pop_transform; end

    #Draws a line from one po to another (last pixel exclusive).
    #Note: OpenGL lines are not reliable at all and may have a missing pixel at the start
    #or end po. Please only use this for debugging purposes. Otherwise, use a quad or
    #image to simulate lines, or contribute a better drawLine to Gosu.
    def draw_line( x1,  y1,  c1, x2,  y2,  c2, z,  mode)
      op = @queues.op_pool.newDrawOp
      op.render_state.mode = mode
      op.vertices_or_block_index = 2
      op.vertices[0].set(x1, y1, c1)
      op.vertices[1].set(x2, y2, c2)
      op.z = z
      @queues.schedule_draw_op op
    end

    def draw_triangle( x1,  y1,  c1, x2,  y2,  c2, x3,  y3,  c3, z,  mode)
      op = @queues.op_pool.newDrawOp
      op.render_state.mode = mode
      op.vertices_or_block_index = 3
      op.vertices[0].set(x1, y1, c1)
      op.vertices[1].set(x2, y2, c2)
      op.vertices[2].set(x3, y3, c3)
      op.z = z
      @queues.schedule_draw_op op
    end

    def draw_quad( x1, y1, c1, x2, y2, c2, x3, y3, c3, x4, y4, c4, z, mode)
      op = @queues.op_pool.newDrawOp
      op.render_state.mode = mode
      op.vertices_or_block_index = 4
      op.vertices[0].set(x1, y1, c1)
      op.vertices[1].set(x2, y2, c2)
      op.vertices[2].set(x3, y3, c3)
      op.vertices[3].set(x4, y4, c4)
      op.z = z
      @queues.schedule_draw_op op
    end

     #TODO If @gl == nil Texture.new will fail, this has to be fixed
    #Turns a portion of a bitmap o something that can be drawn on
    #this graphics object.
    def create_image(src, src_x,  src_y,  src_width,  src_height, border_flags)
      max_size = MAX_TEXTURE_SIZE
      #Special case: If the texture is supposed to have hard borders,
      #is quadratic, has a size that is at least 64 pixels but less than 256
      #pixels and a power of two, create a single texture just for this image.
      if ((border_flags & BF_TILEABLE) == BF_TILEABLE and src_width == src_height and
        (src_width & (src_width - 1)) == 0 and src_width >= 64)

        texture = Texture.new(src_width, @gl)
        #Use the source bitmap directly if the source area completely covers
        #it.
        if (src_x == 0 and src_width == src.width and src_y == 0 and src_height == src.height)
          data = texture.try_alloc(self, @queues, texture, src, 0)
        else
          trimmed_src = Bitmap.new
          trimmed_src.resize(src_width, src_height)
          trimmed_src.insert(src, 0, 0, src_x, src_y, src_width, src_height)
          data = texture.try_alloc(self, @queues, texture, trimmed_src, 0)
        end

        if data == nil
            raise "Internal texture block allocation error"
        end
        return data
      end

      #Too large to fit on a single texture.
      #TODO LargeImageData not implemented yet
      if (src_width > max_size - 2 || src_height > max_size - 2)
        bmp = Bitmap.new(src_width, src_height)
        bmp.insert(src, 0, 0, src_x, src_y, src_width, src_height)
        lidi = LargeImageData.new(self, bmp, max_size - 2, max_size - 2, border_flags)
        return lidi
      end

      bmp = Bitmap.new
      Gosu::apply_border_flags(bmp, src, src_x, src_y, src_width, src_height, border_flags)

      #Try to put the bitmap into one of the already allocated textures.
      @textures.each do |tex|
        data = tex.try_alloc(self, @queues, tex, bmp, 1)
          return data if data != nil
      end

      #All textures are full: Create a new one.
      texture = Texture.new(max_size, @gl)
      @textures.push texture

      data = texture.try_alloc(self, @queues, texture, bmp, 1)
      if data == nil
        raise "Internal texture block allocation error"
      end
      data
    end

    def onDrawFrame(gl)
      #gl.glClear(JavaImports::GL10::GL_COLOR_BUFFER_BIT | JavaImports::GL10::GL_DEPTH_BUFFER_BIT)
      @window.do_show
      rescue Exception => e
        puts "#{ e } (#{ e.class } #{e.message} #{e.backtrace.inspect} )!"
    end

    def onSurfaceChanged(gl, width, height)
      @gl = gl
      @gl.glViewport(0, 0, width, height)
    end

    def onSurfaceCreated(gl, config)
      @gl = gl
      #@queues.gl = @gl
      @android_initializer.on_ready
      #Options to improve performance
      @gl.glDisable(JavaImports::GL10::GL_DITHER)
      @gl.glHint(JavaImports::GL10::GL_PERSPECTIVE_CORRECTION_HINT, JavaImports::GL10::GL_FASTEST)

      @gl.glMatrixMode(JavaImports::GL10::GL_PROJECTION)
      @gl.glLoadIdentity
      @gl.glViewport(0, 0, @window.width, @window.height)

      @gl.glOrthof(0, @window.width, @window.height, 0, -1, 1)


      @gl.glMatrixMode(JavaImports::GL10::GL_MODELVIEW)
      @gl.glLoadIdentity

      @gl.glEnable(JavaImports::GL10::GL_BLEND)
      rescue Exception => e
        puts "#{ e } (#{ e.class } #{e.message} #{e.backtrace.inspect} )!"
    end
  end
end
