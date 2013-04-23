require 'gosu_android/input/buttons'

module Gosu
  class Button
    attr_reader :id
    def initialize(*args)
      case args.length
      when 0
        @id = NoButton
      when 1
        @id = args[0]
      else
        raise ArgumentError
      end
    end

    # Tests whether two Buttons identify the same physical button.
    def == other
      self.id == other.id
    end

    def > other
      self.id > other.id
    end

    def < other
      self.id < other.id
    end
  end

  # Struct that saves information about a touch on the surface of a multi-
  # touch device.
  class Touch < Struct.new(:id, :x, :y); end


  # Manages initialization and shutdown of the input system. Only one Input
  # instance can exist per application.
  class Input

    def initialize(display, window)
      @display = display
      @window = window
      @touch_event_list = []
      @key_event_list_up = []
      @key_event_list_down = []
      @id = 0
      @ingnore_buttons = [JavaImports::KeyEvent::KEYCODE_VOLUME_DOWN, 
        JavaImports::KeyEvent::KEYCODE_VOLUME_MUTE, 
        JavaImports::KeyEvent::KEYCODE_VOLUME_UP,
        JavaImports::KeyEvent::KEYCODE_BACK,
        JavaImports::KeyEvent::KEYCODE_HOME,
        JavaImports::KeyEvent::KEYCODE_MENU,
        JavaImports::KeyEvent::KEYCODE_POWER,
        JavaImports::KeyEvent::KEYCODE_APP_SWITCH, 
        JavaImports::KeyEvent::KEYCODE_UNKNOWN]      
    end

    def feed_touch_event(event)
      @touch_event_list.push event
    end

    def feed_key_event_down(keyCode)
      if @ingnore_buttons.include? keyCode
        return false
      end  
      @key_event_list_down.push keyCode
      return true
    end

    def feed_key_event_up(keyCode)
      if @ingnore_buttons.include? keyCode
        return false
      end  
      @key_event_list_up.push keyCode
      return true
    end

    # Returns the character a button usually produces, or 0.
    def id_to_char(btn); end

    # Returns the button that has to be pressed to produce the
    # given character, or noButton.
    def char_to_id(ch); end

    # Returns true if a button is currently pressed.
    # Updated every tick.
    def button_down?(id)
      return @key_event_list_down.include? id
    end

    # Returns the horizontal position of the mouse relative to the top
    # left corner of the window given to Input's constructor.
    def mouseX; end

    # Returns true if a button is currently pressed.
    # Updated every tick.
    def mouseY; end

    # Immediately moves the mouse as far towards the desired position
    # as possible. x and y are relative to the window just as in the mouse
    # position accessors.
    def set_mouse_position(x,  y); end

    # Undocumented for the moment. Also applies to currentTouches().
    def set_mouse_factors(factorX,  factorY); end

    # Currently known touches.
    def currentTouches; end

    # Accelerometer positions in all three dimensions (smoothened).
    def accelerometerX; end
    def accelerometerY; end
    def accelerometerZ; end

    # Collects new information about which buttons are pressed, where the
    # mouse is and calls onButtonUp/onButtonDown, if assigned.
    def update
      @touch_event_list.each do |touch_event|
        touch_event.getPointerCount.times do |index|
          touch = Touch.new(touch_event. getPointerId(index), touch_event.getX(index), touch_event.getY(index))
          case touch_event.getAction
          when JavaImports::MotionEvent::ACTION_DOWN
            @window.touch_began(touch)
          when JavaImports::MotionEvent::ACTION_MOVE
            @window.touch_moved(touch)
          when JavaImports::MotionEvent::ACTION_UP
            @window.touch_ended(touch)
          end
        end
      end      
      
      @key_event_list_down.each do |key_event|
        @window.button_down key_event
      end
      
      @key_event_list_up.each do |key_event|
        @window.button_up key_event
      end       

    end
    
    def clear
      @touch_event_list.clear
      @key_event_list_down.clear
      @key_event_list_up.clear        
    end

    # Assignable events that are called by update. You can bind these to your own functions.
    # If you use the Window class, it will assign forward these to its own methods.
    def button_down; end
    def button_up; end

    # Returns the currently active TextInput instance, or 0.
    def text_input; end
    # Sets the currently active TextInput, or clears it (input = 0).
    def set_text_input(input); end
  end
end
