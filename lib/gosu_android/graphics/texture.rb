require 'gosu_android/graphics/blockAllocator'
require 'gosu_android/graphics/texChunk'
require 'gosu_android/requires'

module Gosu
  class Texture

    def initialize(size, gl)
      @size = size
      @allocator = BlockAllocator.new(@size, @size)
      @num = 0
      @gl = gl
      @name = [0].to_java(:int)
      @gl.glGenTextures(1, @name, 0)
      if @name[0] == -1
        raise "Couldn't create OpenGL texture"
      end
      @gl.glBindTexture(JavaImports::GL10::GL_TEXTURE_2D, @name[0])

      @gl.glTexImage2D(JavaImports::GL10::GL_TEXTURE_2D, 0, JavaImports::GL10::GL_RGBA, @allocator.width,
        @allocator.height, 0, JavaImports::GL10::GL_RGBA, JavaImports::GL10::GL_UNSIGNED_BYTE, nil)
=begin
      #TODO Should create an empty texture to be filled later
      pixel = [0]
      pbb = JavaImports::ByteBuffer.allocateDirect(pixel.length*4)
      pbb.order(JavaImports::ByteOrder.nativeOrder)
      pixel_buffer = pbb.asIntBuffer
      pixel_buffer.put(pixel.to_java(:int))
      pixel_buffer.position(0)
      JavaImports::GLUtils.texImage2D(JavaImports::GL10::GL_TEXTURE_2D, 0, 4, @allocator.width, @allocator.height, 0,
                 JavaImports::GL10::GL_RGBA, JavaImports::GL10::GL_UNSIGNED_BYTE, pixel_buffer)

      @gl.glTexImage2D(JavaImports::GL10::GL_TEXTURE_2D, 0, 4, @allocator.width, @allocator.height, 0,
                 JavaImports::GL10::GL_RGBA, JavaImports::GL10::GL_UNSIGNED_BYTE, pixel_buffer)

      @gl.glTexParameterf(JavaImports::GL10::GL_TEXTURE_2D,
        JavaImports::GL10::GL_TEXTURE_MIN_FILTER, JavaImports::GL10::GL_LINEAR)
      @gl.glTexParameteri(JavaImports::GL10::GL_TEXTURE_2D,
        JavaImports::GL10::GL_TEXTURE_WRAP_S, JavaImports::GL10::GL_CLAMP_TO_EDGE)
      @gl.glTexParameteri(JavaImports::GL10::GL_TEXTURE_2D,
        JavaImports::GL10::GL_TEXTURE_WRAP_T, JavaImports::GL10::GL_CLAMP_TO_EDGE)
=end
      @gl.glTexParameterf(JavaImports::GL10::GL_TEXTURE_2D, JavaImports::GL10::GL_TEXTURE_MIN_FILTER, JavaImports::GL10::GL_NEAREST)
      @gl.glTexParameterf(JavaImports::GL10::GL_TEXTURE_2D, JavaImports::GL10::GL_TEXTURE_MAG_FILTER, JavaImports::GL10::GL_LINEAR)
    end

    def finalize
      tbb = (JavaImports::ByteBuffer.allocateDirect(4))
      tbb.order(JavaImports::ByteOrder.nativeOrder)
      texture_buffer = tbb.asIntBuffer
      texture_buffer.put(@name)
      texture_buffer.position(0)      
      @gl.glDeleteTextures(1, texture_buffer)
    end

    def tex_name
      @name[0]
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

      @gl.glTexSubImage2D(JavaImports::GL10::GL_TEXTURE_2D, 0, block.left, block.top, block.width, block.height,
        Color::GL_FORMAT, JavaImports::GL10::GL_UNSIGNED_BYTE, bmp.data_java)
      #@gl.glBindTexture(JavaImports::GL10::GL_TEXTURE_2D, @name[0])
      #JavaImports::GLUtils.texImage2D(JavaImports::GL10::GL_TEXTURE_2D, 0, bmp.to_open_gl, 0)

      @num += 1
      result
    end

    def free(x, y)
      @allocator.free(x, y)
      @num -= 1
    end

  end
end
