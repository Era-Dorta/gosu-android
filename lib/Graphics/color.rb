#require 'math.rb'

module Gosu
  
  class HSV < Struct.new(:h, :s, :v)
  end

  class Color
    private
    def force_overflow(i)
      if i < -2147483648
          i & 0xffffffff 
      elsif i > 2147483647 
          -(-(i) & 0xffffffff)
      else  
          i
      end    
    end  
    
    public
    RED_OFFSET = 0
    GREEN_OFFSET = 8
    BLUE_OFFSET = 16
    ALPHA_OFFSET = 24 
    GL_FORMAT = 0x1908
    def initialize(*args)
      case args.length
      #When no argument is given, do nothing
      when 0
      
      #Constructor for literals of the form 0xaarrggbb.  
      when 1
        initialize((args[0] >> 24) & 0xff, (args[0] >> 16) & 0xff,
               (args[0] >>  8) & 0xff, (args[0] >>  0) & 0xff)
               
      #Constructor from red, green and blue         
      when 3
        initialize(0xff, args[0], args[1], args[2])  
        
      #Constructor for alpha, Channel red, Channel green, Channel blue
      when 4
          @rep = force_overflow((args[0] << ALPHA_OFFSET) | (args[1] << RED_OFFSET) |
                  (args[2] << GREEN_OFFSET) | (args[3] << BLUE_OFFSET))
      else
        raise ArgumentError
      end      
    end
    
    #Return internal representation of the color
    def gl
      @rep
    end
    
    def red
      (@rep >> RED_OFFSET)&0x000000FF
    end

    def green
      (@rep >> GREEN_OFFSET)&0x000000FF
    end

    def blue
      (@rep >> BLUE_OFFSET)&0x000000FF
    end

    def alpha
      (@rep >> ALPHA_OFFSET)&0x000000FF
    end

    def red= value
        @rep &= ~(0xff << RED_OFFSET)
        @rep |= value << RED_OFFSET
    end


    def green= value
        @rep &= ~(0xff << GREEN_OFFSET)
        @rep |= value << GREEN_OFFSET
    end
    
    def blue= value
        @rep &= ~(0xff << BLUE_OFFSET)
        @rep |= value << BLUE_OFFSET
    end

    def alpha= value
        @rep &= ~(0xff << ALPHA_OFFSET)
        @rep |= value << ALPHA_OFFSET
    end    
    
    def == other   
      @rep == other.gl
    end 
    
    def from_HSV(h, s, v)
      fromAHSV(255, h, s, v)
    end
    
    def from_AHSV(alpha, h, s, v)
      if (s == 0)
        #Grey.
            return Color.new(alpha, v * 255, v * 255, v * 255)
      end  
      #Normalize hue
      #TODO include math code
      #h = normalizeAngle(h)
        
      sector = (h.to_f / 60).round
      factorial = h.to_f / 60 - sector
        
      p = v * (1 - s)
      q = v * (1 - s * factorial)
      t = v * (1 - s * (1 - factorial))
      
      case sector 
      when 0
          return Color.new(alpha, v * 255, t * 255, p * 255)
      when 1
          return Color.new(alpha, q * 255, v * 255, p * 255)
      when 2
          return Color.new(alpha, p * 255, v * 255, t * 255)
      when 3
          return Color.new(alpha, p * 255, q * 255, v * 255)
      when 4
          return Color.new(alpha, t * 255, p * 255, v * 255)
      else #sector 5
          return Color.new(alpha, v * 255, p * 255, q * 255)
      end      
    end
    
    Gosu::Color::NONE = Color.new(0x00000000)
    Gosu::Color::BLACK = Color.new(0xff000000)
    Gosu::Color::GRAY = Color.new(0xff808080)
    Gosu::Color::WHITE = Color.new(0xffffffff)
    Gosu::Color::AQUA = Color.new(0xff00ffff)
    Gosu::Color::RED = Color.new(0xffff0000)
    Gosu::Color::GREEN = Color.new(0xff00ff00)
    Gosu::Color::BLUE = Color.new(0xff0000ff)
    Gosu::Color::YELLOW = Color.new(0xffffff00)
    Gosu::Color::FUCHSIA = Color.new(0xffff00ff)
    Gosu::Color::CYAN = Color.new(0xff00ffff)    
  end
end