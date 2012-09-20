require 'blockAllocator'
require 'texRequires'

module Gosu
  class Texture
    
    def initialize(size, gl)
      #Set finalize
      ObjectSpace.define_finalizer(self,
                          self.class.method(:finalize).to_proc)         
      @size = size
      @allocator = BlockAllocator.new(@size, @size)
      @num = 0
      @gl = gl
      @name = [1]
      @gl.glGenTextures(1, @name.to_java(:int), 0)
      if @name[0] == -1
        raise "Couldn't create OpenGL texture"
      end 
      @gl.glBindTexture(JavaImports::GL10::GL_TEXTURE_2D, @textures[0])
      #TODO Not sure wheter this should be here or not
      @gl.glTexImage2D(JavaImports::GL_TEXTURE_2D, 0, 4, @allocator.width, @allocator.height, 0,
                 JavaImports::GL_RGBA, JavaImports::GL_UNSIGNED_BYTE, 0)
                 
      @gl.glTexParameterf(JavaImports::GL10::GL_TEXTURE_2D, 
        JavaImports::GL10::GL_TEXTURE_MIN_FILTER, JavaImports::GL10::GL_LINEAR)    
      @gl.glTexParameteri(JavaImports::GL10::GL_TEXTURE_2D, 
        JavaImports::GL10::GL_TEXTURE_WRAP_S, JavaImports::GL10::GL_CLAMP_TO_EDGE)
      @gl.glTexParameteri(JavaImports::GL10::GL_TEXTURE_2D, 
        JavaImports::GL10::GL_TEXTURE_WRAP_T, JavaImports::GL10::GL_CLAMP_TO_EDGE)         
    end
    
    def Texture.finalize(id)
      @gl.glDeleteTextures(1, @name.to_java(:int))
    end
    
    def tex_name
      @name
    end
    
    def size
      @allocator.width
    end
    
    def try_alloc(graphics, queues, ptr, bmp, padding)
      alloc_info = @allocator.alloc(bmp.width, bmp.height)
      if (not alloc_info[0])
          return nil
      end    
      block = alloc_info[1]
      result = TexChunk.new(graphics, queues, ptr, block.left + padding, block.top + padding,
                                block.width - 2 * padding, block.height - 2 * padding, padding)
      
      @gl.glBindTexture(JavaImports::GL10::GL_TEXTURE_2D, @name.to_java(:int))
      @gl.glTexSubImage2D(JavaImports::GL10::GL_TEXTURE_2D, 0, block.left, block.top, 
        block.width, block.height, Color::GL_FORMAT, JavaImports::GL10::GL_UNSIGNED_BYTE, bmp.data)
  
      num += 1
      result
    end
    
    def free(x, y) 
      @allocator.free(x, y)
      @num -= 1
    end
    
  end
end