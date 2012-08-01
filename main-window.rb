require 'requires'

module Gosu
  
  class RubotoGLSurfaceViewRenderer
    def initialize
    end
    
    def onDrawFrame(gl)
      gl.glClear(JavaImports::GL10::GL_COLOR_BUFFER_BIT | JavaImports::GL10::GL_DEPTH_BUFFER_BIT)
    end
  
    def onSurfaceChanged(gl, width, height)
      gl.glViewport(0, 0, width, height)
    end
  
    def onSurfaceCreated(gl, config)
        gl.glClearColor(1,1,1,1)
    end
  end
  
  ruboto_generate(android.opengl.GLSurfaceView => "TouchSurfaceView")
  
  class Window
    attr_accessor :caption
    attr_accessor :mouse_x
    attr_accessor :mouse_y
    attr_accessor :text_input
    attr_reader :width, :height
    attr_reader :fullscreen?
    attr_reader :update_interval
    
    # update_interval:: Interval in milliseconds between two calls
    # to the update member function. The default means the game will run
    # at 60 FPS, which is ideal on standard 60 Hz TFT screens.
    def initialize(width, height, fullscreen, update_interval=16.666666)  
      @fullscreen = fullscreen
      @showing = false
      @display = $gosu.getWindowManager.getDefaultDisplay
      @width = width
      @height= height
      #@width = @display.getWidth
      #@height = @display.getHeight
      #setLayout(int width, int height)
      #@width = $gosu.get_window.rect.width
      #@height = $gosu.get_window.rect.height 
      #@width = @display.getMeasureWidth
      #@height = @display.getMeasureHeight      
      @surface_view = TouchSurfaceView.new($gosu)
      @surface_view.initialize_ruboto_callbacks do
        def on_touch_event(event)
          if event.getAction == JavaImports::MotionEvent::ACTION_DOWN
            puts "tocado"
            request_render
          end      
          return true 
        end
      end      
      #@width = @surface_view.rect.width
      #@height = @surface_view.rect.height 
      @surface_view.renderer = RubotoGLSurfaceViewRenderer.new    
    end
    
    # Enters a modal loop where the Window is visible on screen and receives calls to draw, update etc.
    def show
      @showing = true
      if @fullscreen
        #Use full java path for Window, since there is a Gosu::Window
        $gosu.request_window_feature(JavaImports::Window::FEATURE_NO_TITLE)
        $gosu.get_window.set_flags(JavaImports::WindowManager::LayoutParams::FLAG_FULLSCREEN,
            JavaImports::WindowManager::LayoutParams::FLAG_FULLSCREEN)
        $gosu.content_view = @surface_view 
        @window = $gosu.getWindow            
      else      
        $gosu.setTitle @caption
        $gosu.content_view = @surface_view 
        @window = $gosu.getWindow  
        @window.setLayout(width, height)        
      end                                
      puts "el surface mide #{@surface_view.getWidth}, #{@surface_view.getMeasuredWidth}"            
      #@activity = $gosu
    end
    
    # Tells the window to end the current show loop as soon as possible.
    def close; end 
    
    # Called every update_interval milliseconds while the window is being
    # shown. Your application's main game logic goes here.
    def update; end
    
    # Called after every update and when the OS wants the window to
    # repaint itself. Your application's rendering code goes here.
    def draw; end
    
    # Can be overriden to give the game a chance to say no to being redrawn.
    # This is not a definitive answer. The operating system can still cause
    # redraws for one reason or another.
    #
    # By default, the window is redrawn all the time (i.e. Window#needs_redraw?
    # always returns true.)
    def needs_redraw?; end
    
    # Can be overriden to show the system cursor when necessary, e.g. in level
    # editors or other situations where introducing a custom cursor is not
    # desired.
    def needs_cursor?; end
    
    # Called before update when the user pressed a button while the
    # window had the focus.
    def button_down(id); end
    # Same as buttonDown. Called then the user released a button.
    def button_up(id); end
    
    # Returns true if a button is currently pressed. Updated every tick.
    def button_down?(id); end
    
    # Draws a line from one point to another (last pixel exclusive).
    # Note: OpenGL lines are not reliable at all and may have a missing pixel at the start
    # or end point. Please only use this for debugging purposes. Otherwise, use a quad or
    # image to simulate lines, or contribute a better draw_line to Gosu.
    def draw_line(x1, y1, c1, x2, y2, c2, z=0, mode=:default); end
    
    def draw_triangle(x1, y1, c1, x2, y2, c2, x3, y3, c3, z=0, mode=:default); end
    
    # Draws a rectangle (two triangles) with given corners and corresponding
    # colors.
    # The points can be in clockwise order, or in a Z shape.
    def draw_quad(x1, y1, c1, x2, y2, c2, x3, y3, c3, x4, y4, c4, z=0, mode=:default); end
    
    # Flushes all drawing operations to OpenGL so that Z-ordering can start anew. This
    # is useful when drawing several parts of code on top of each other that use conflicting
    # z positions.
    def flush; end
    
    # For custom OpenGL calls. Executes the given block in a clean OpenGL environment.
    # Use the ruby-opengl gem to access OpenGL function (if you manage to get it to work).
    # IF no z position is given, it will execute the given block immediately, otherwise,
    # the code will be scheduled to be called between Gosu drawing operations.
    #
    # Note: You cannot call Gosu rendering functions within this block, and you can only
    # call the gl function in the call tree of Window#draw.
    #
    # See examples/OpenGLIntegration.rb for an example.
    def gl(z=nil, &custom_gl_code); end
    
    # Limits the drawing area to a given rectangle while evaluating the code inside of the block.
    def clip_to(x, y, w, h, &rendering_code); end
    
    # Returns a Gosu::Image that containes everything rendered within the given block. It can be
    # used to optimize rendering of many static images, e.g. the map. There are still several
    # restrictions that you will be informed about via exceptions.
    #
    # The returned Gosu::Image will have the width and height you pass as arguments, regardless
    # of how the area you draw on. It is important to pass accurate values if you plan on using
    # Gosu::Image#draw_as_quad or Gosu::Image#draw_rot with the result later.
    #
    # @return [Gosu::Image]
    def record(width, height, &rendering_code); end
    
    # Rotates everything drawn in the block around (around_x, around_y).
    def rotate(angle, around_x=0, around_y=0, &rendering_code); end
    
    # Scales everything drawn in the block by a factor.
    def scale(factor_x, factor_y=factor_x, &rendering_code); end
    
    # Scales everything drawn in the block by a factor for each dimension.
    def scale(factor_x, factor_y, around_x, around_y, &rendering_code); end
    
    # Moves everything drawn in the block by an offset in each dimension.
    def translate(x, y, &rendering_code); end
    
    # Applies a free-form matrix rotation to everything drawn in the block.
    def transform(m0, m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12, m13, m14, m15, &rendering_code); end
    
    # Returns the character a button usually produces, or nil. To implement real text-input
    # facilities, look at the TextInput class instead.
    def self.button_id_to_char(id); end
    
    # Returns the button that has to be pressed to produce the given character, or nil.
    def self.char_to_button_id(char); end
    
    # @deprecated Use Window#mouse_x= and Window#mouse_y= instead.
    def set_mouse_position(x, y); end
  end
end  