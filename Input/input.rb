require 'buttons'

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
    end
    
    def feed_touch_event(type, touches); end  
  
    # Returns the character a button usually produces, or 0.
    def id_to_char(btn); end
    
    # Returns the button that has to be pressed to produce the
    # given character, or noButton.
    def char_to_id(ch); end

    # Returns true if a button is currently pressed.
    # Updated every tick.    
    def down(btn); end

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
    def update; end
    
    # Assignable events that are called by update. You can bind these to your own functions.
    # If you use the Window class, it will assign forward these to its own methods.
    def button_down; end
    def button_up; end
    
    # Assignable events that are called by update. You can bind these to your own functions.
    # If you use the Window class, it will assign forward these to its own methods.
    def touch_began; end
    def touch_moved; end
    def touch_ended; end
    
    # Returns the currently active TextInput instance, or 0.
    def text_input; end 
    # Sets the currently active TextInput, or clears it (input = 0).
    def set_text_input(input); end
  end  
end