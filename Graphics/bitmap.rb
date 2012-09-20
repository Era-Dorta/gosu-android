require 'requires'
require 'color'

module Gosu
  class Bitmap
    
    def initialize(*args)
      case args.length
      when 0
        @w = 0
        @h = 0
      when 1
          
      when 2
        @w = args[0]
        @h = args[1]
        @c = 
        @pixels = Array.new(@w*@h, @c)
        if @w > 0 and @h > 0
          @bitmap = JavaImports::Bitmap.createBitmap(@w, @h, JavaImports::Bitmap::Config::ARGB_8888)
        end  
      when 3   
        @w = args[0]
        @h = args[1]
        @pixels = Array.new(@w*@h, Color::NONE)
        if @w > 0 and @h > 0
          @bitmap = JavaImports::Bitmap.createBitmap(@w, @h, JavaImports::Bitmap::Config::ARGB_8888)
        end         
      else
        raise ArgumentError
      end     
    end
    
    private
    def initialize_3(w, h, c = Color::NONE)
      @w = w
      @h = h
      @c = c
      @pixels = Array.new(@w*@h, c)
      if @w > 0 and @h > 0
        @bitmap = JavaImports::Bitmap.createBitmap(@w, @h, JavaImports::Bitmap::Config::ARGB_8888)
        @bitmap.eraseColor(c.gl)
      end       
    end
    
    public
  end
  
  #TODO define load_image with reader argument
  def load_image_file(file_name)
    Gosu::Bitmap.new(JavaImports::BitmapFactory.decodeFile(file_name))
  end
end