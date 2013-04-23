require 'gosu_android/requires'

require 'gosu_android/graphics/graphics'
require 'gosu_android/graphics/graphicsBase'
require 'gosu_android/graphics/font'
require 'gosu_android/input/input'
require 'gosu_android/audio/audio'
require 'gosu_android/timing'

require 'singleton'
require 'ruboto/util/toast'


module Gosu

  class AndroidInitializer
    include Singleton
    attr_reader :graphics, :surface_view
    attr_reader :activity

    def start activity
      activity.toast 'Still loading please wait'
      @activity = activity
      @surface_view = GosuSurfaceView.new(@activity)
      @graphics = Graphics.new(self)
      @surface_view.renderer =  @graphics
      @activity.content_view = @surface_view
      activity.toast 'Still loading please wait'
    end

    def on_ready
      @activity.on_ready
    end
  end

  class GosuSurfaceView < JavaImports::GLSurfaceView

    def atributes(window, input)
      @window = window
      @input = input
    end

    def onTouchEvent(event)
      super
      @input.feed_touch_event(event)
      return true
    end

    def onWindowFocusChanged(has_focus)
      super
      if(@window)
        @window.focus_changed(has_focus, self.get_width, self.get_height)
      end
      return true
    end
  end


  class Window
    attr_accessor :caption
    attr_accessor :mouse_x
    attr_accessor :mouse_y
    attr_accessor :text_input
    attr_accessor :media_player
    attr_reader :width, :height
    attr_reader :fullscreen
    attr_reader :internal_update_interval
    attr_reader :update_interval
    attr_reader :fonts_manager
    attr_reader :activity

    # update_interval:: Interval in milliseconds between two calls
    # to the update member function. The default means the game will run
    # at 60 FPS, which is ideal on standard 60 Hz TFT screens.
    def initialize(width, height, fullscreen, update_interval=16.666666)
      android_initializer = AndroidInitializer.instance
      @fullscreen = fullscreen
      @showing = false
      @activity = android_initializer.activity
      @display = @activity.getWindowManager.getDefaultDisplay
      @width = width
      @height= height
      @internal_update_interval = update_interval/1000.0
      @update_interval = update_interval
      #@surface_view = GosuSurfaceView.new(@activity)
      @surface_view = android_initializer.surface_view
      @input = Input.new(@display, self)
      @surface_view.atributes(self, @input)
      #@graphics = Graphics.new(@width, @height, @fullscreen, self)
      @graphics = android_initializer.graphics
      @graphics.initialize_window(@width, @height, @fullscreen, self)
      #@surface_view.renderer =  @graphics
      @surface_view.set_render_mode(JavaImports::GLSurfaceView::RENDERMODE_WHEN_DIRTY)
      @fonts_manager = FontsManager.new self
      @media_player = nil
      add_key_event_listener
      @activity.input = @input
      @showing_keyboard = false
    end

    #TODO This is monkey patching, there has to be a better way to do it 
    #This method adds listeners to the activity that called gosu 
    #becouse the key events can only be cought in the activity 
    
    #TODO At least check if the methods were already defined,
    #if so called them after/before this methods
    def add_key_event_listener
      # Get the class of the object.
      @activity.class.class_eval do
        
        attr_accessor :input
        
        def on_destroy
          super
          #Release audio resources
          Song.release_resources         
        end
        
        def onKeyDown(keyCode, event)      
          if @input.feed_key_event_down(keyCode)
            return true
          else
            return super keyCode, event
          end
        end
    
        def onKeyUp(keyCode, event)        
          if @input.feed_key_event_up(keyCode)
            return true
          else
            return super keyCode, event
          end
        end

        #TODO It does never get called, it does not matter how long
        #the press was
        def onKeyLongPress(keyCode, event) 
          if @input.feed_key_event_up(keyCode)
            return true
          else
            return super keyCode, event
          end
        end
        
      end
    end
  
    # Enters a modal loop where the Window is visible on screen and receives calls to draw, update etc.
    def show
      @showing = true
      if @fullscreen
        #Use full java path for Window, since there is a Gosu::Window
        @activity.request_window_feature(JavaImports::Window::FEATURE_NO_TITLE)
        @activity.get_window.set_flags(JavaImports::WindowManager::LayoutParams::FLAG_FULLSCREEN,
            JavaImports::WindowManager::LayoutParams::FLAG_FULLSCREEN)
        #@activity.content_view = @surface_view
        @window = @activity.getWindow
        #Replace position and size with gosu metrics
      else
        @window = @activity.getWindow
        #Only the thread that created the view can change it, so setLayout
        #and setTitle cannot be executed here
        p = Proc.new do
          @window.setLayout(@width, @height)
          @activity.setTitle @caption
        end
        @activity.runOnUiThread(p)
      end
      @screen_width = @surface_view.get_width
      @screen_height = @surface_view.get_height
    end

    def do_show
      @start_time = Time.now
      do_tick
      #TODO gosu dark side
      @end_time = Time.now
      if (@start_time <= @end_time and (@end_time - @start_time) < @internal_update_interval)
          sleep(@internal_update_interval - (@end_time - @start_time))
      end
    end

    # Tells the window to end the current show loop as soon as possible.
    def close     
      #Self trigger window lost focus, since we are going to home
      focus_changed false, @screen_width, @screen_height
      @showing = false
      @activity.moveTaskToBack(true)
    end

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
    def button_down?(id)
      return @input.button_down? id
    end

    # Called when the user started a touch on the screen
    def touch_began(touch); end
    # Called when the user continue a touch on the screen
    def touch_moved(touch); end
    # Called when the user finished a touch on the screen
    def touch_ended(touch); end

    # Called when and object collides with another object
    def object_collided(x, y, object); end

    # Draws a line from one point to another (last pixel exclusive).
    # Note: OpenGL lines are not reliable at all and may have a missing pixel at the start
    # or end point. Please only use this for debugging purposes. Otherwise, use a quad or
    # image to simulate lines, or contribute a better draw_line to Gosu.
    def draw_line(x1, y1, c1, x2, y2, c2, z=0, mode=:default)
      @graphics.draw_line(x1, y1, c1, x2, y2, c2, z, AM_MODES[mode])
    end

    def draw_triangle(x1, y1, c1, x2, y2, c2, x3, y3, c3, z=0, mode=:default)
      @graphics.draw_triangle(x1, y1, c1, x2, y2, c2, x3, y3, c3, z, AM_MODES[mode])
    end

    # Draws a rectangle (two triangles) with given corners and corresponding
    # colors.
    # The points can be in clockwise order, or in a Z shape.
    def draw_quad(x1, y1, c1, x2, y2, c2, x3, y3, c3, x4, y4, c4, z=0, mode=:default)
      @graphics.draw_quad(x1, y1, c1, x2, y2, c2, x3, y3, c3, x4, y4, c4, z, AM_MODES[mode])
    end

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

    def caption= value
      @caption = value
      if @showing and not @fullscreen
        p = Proc.new do
          @activity.setTitle @caption
        end
        @activity.runOnUiThread(p)
      end
    end

    def do_tick
      @input.update
      self.update
      @input.clear
      @graphics.begin(Color::BLACK)
      self.draw
      @graphics.end
      @surface_view.request_render
    end

    #TODO On screen rotation the app breaks down
    def focus_changed has_focus, width, height
      @screen_width = width
      @screen_height = height
      
      if has_focus
               
        if @showing and @media_player != nil
            @media_player.start
        end

        #TODO Keyboard does not appears again
        if @showing_keyboard
          show_soft_keyboard
        end
       
      else
        #Hide keyboard but mark it so it will be shown later
        if @showing_keyboard
          hide_soft_keyboard
          @showing_keyboard = true
        end
        
        if @showing and @media_player != nil
            @media_player.pause
        end
        
      end   
      return true  
    end

    #TODO It would be nice that the keyboard was transparent
    def show_soft_keyboard             
      context = @activity.getApplicationContext
      imm = context.getSystemService(Context::INPUT_METHOD_SERVICE)
      imm.toggleSoftInput(JavaImports::InputMethodManager::SHOW_FORCED,0)
      @showing_keyboard = true
    end
    
    def hide_soft_keyboard
      context = @activity.getApplicationContext
      imm = context.getSystemService(Context::INPUT_METHOD_SERVICE)
      imm.toggleSoftInput(JavaImports::InputMethodManager::HIDE_IMPLICIT_ONLY,0)    
      @showing_keyboard = false
    end

    def create_image(source, src_x, src_y, src_width, src_height, tileable)
      @graphics.create_image(source, src_x, src_y, src_width, src_height, tileable)
    end

  end
end
