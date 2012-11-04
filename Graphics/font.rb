require 'requires'
require 'color'
require 'graphicsBase'
require 'bitmap'

module Gosu
  
  class Font
    attr_reader :name, :flags
    def initialize(window, font_name, font_height, font_flags = :ff_bold)
      @window = window
      @name = font_name
      @height = font_height * 2
      @flags = flags
      
      @paint = JavaImports::Paint.new     

      @paint.setStyle(JavaImports::Paint::Style::FILL)
      @paint.setTextSize(@height)
      @paint.setAntiAlias(true)
      @paint.setTypeface(font_name)             
    end
    
    def height
      @height / 2
    end
    
    #Draws text so the top left corner of the text is at (x; y).
    #param text Formatted text without line-breaks.
    def draw(text, x, y, z, factor_x = 1, factor_y = 1, c = Color::WHITE, 
      mode = AM_DEFAULT)
      #To avoid creating the bitmap every frame check is the text or color
      #has change. If any changed create a new Image, otherwise just draw the
      #image that was created on some previous call
      if(@text != text or @c != c) 
        @text = text
        if c.class != Color
          c = Color.new c
        end
        @c = c
        @paint.setARGB(@c.alpha, @c.red, @c.green, @c.blue)
        bitmap_java = JavaImports::Bitmap.createBitmap(@paint.measureText(text), @height, JavaImports::Bitmap::Config::RGB_565)
        @canvas = JavaImports::Canvas.new(bitmap_java)
        #TODO Make a real solution, this is crappy
        #This should put the background in transparent color but it does not
        @canvas.drawARGB(Color::NONE.alpha, Color::NONE.red, Color::NONE.green, Color::NONE.blue)
        @canvas.drawText(@text, 0, @height, @paint)    
        bitmap = Bitmap.new bitmap_java     
        #So before creating the image change every black pixel to a transparent pixel
        bitmap.replace(Color::BLACK, Color::NONE)
        @image = Image.new(@window, bitmap)
      end  
      @image.draw(x, y, z, factor_x, factor_y, c, mode)
    end  
    
  end
  
  def self.default_font_name
    JavaImports::Typeface::MONOSPACE
  end
  
end