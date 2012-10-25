require 'renderState'
require 'common'

module Gosu
  class DrawOp < Struct.new(:z, :vertices_or_block_index, :top, :left, :bottom, :right, :render_state, :vertices)  
    
    class Vertex < Struct.new(:x, :y, :c); end  
    
    def initialize(gl)
      @gl = gl  
      self[:vertices] = Array.new
      self[:render_state] = RenderState.new
    end
    
    def perform(nextOp)
      if self[:vertices_or_block_index] < 2 or self[:vertices_or_block_index] > 4
        raise "Wrong vertices_or_block_index"
      end
      @gl.glEnableClientState(JavaImports::GL10::GL_VERTEX_ARRAY) 

      
      index = []      
      if self[:render_state].tex_name != NO_TEXTURE
        @gl.glEnableClientState(JavaImports::GL10::GL_TEXTURE_COORD_ARRAY)
        
        texture = []
        i = 0
        self[:vertices].each do |vertex|          
          index.push vertex.x
          index.push vertex.y
          index.push 0
          
          case i
          when 0
            texture.push left, top 
          when 1
            texture.push right, top
          when 2
            texture.push left, bottom            
          when 3
            texture.push right, bottom
            i = -1
          end
          i += 1
        end
        
        tbb = JavaImports::ByteBuffer.allocateDirect(texture.length*4)
        tbb.order(JavaImports::ByteOrder.nativeOrder)
        texture_buffer = tbb.asFloatBuffer
        texture_buffer.put(texture.to_java(:float))
        texture_buffer.position(0) 
      else      
        @gl.glEnableClientState(JavaImports::GL10::GL_COLOR_ARRAY) 
        color = []
          
        self[:vertices].each do |vertex|
          color.push vertex.c.red
          color.push vertex.c.green
          color.push vertex.c.blue
          color.push vertex.c.alpha
          
          index.push vertex.x
          index.push vertex.y
          index.push 0
        end
        
        cbb = JavaImports::ByteBuffer.allocateDirect(color.length*4)
        cbb.order(JavaImports::ByteOrder.nativeOrder)
        color_buffer = cbb.asFloatBuffer
        color_buffer.put(color.to_java(:float))
        color_buffer.position(0)         
      end
             
    
      vbb = JavaImports::ByteBuffer.allocateDirect(index.length*4)
      vbb.order(JavaImports::ByteOrder.nativeOrder)
      vertex_buffer = vbb.asFloatBuffer
      vertex_buffer.put(index.to_java(:float))
      vertex_buffer.position(0)

      if self[:render_state].tex_name == NO_TEXTURE
        @gl.glColorPointer(4, JavaImports::GL10::GL_FLOAT, 0, color_buffer)
      end 
      
      @gl.glVertexPointer(3, JavaImports::GL10::GL_FLOAT, 0, vertex_buffer)
      
      if self[:render_state].tex_name != NO_TEXTURE      
        @gl.glTexCoordPointer(2, JavaImports::GL10::GL_FLOAT, 0, texture_buffer)  
      end
            
      case self[:vertices_or_block_index]
      when 2
        @gl.glDrawArrays(JavaImports::GL10::GL_LINE_STRIP, 0, 2)   
      when 3
        @gl.glDrawArrays(JavaImports::GL10::GL_TRIANGLE_STRIP, 0, 3)
      when 4
        #This draws a quad using two triangles
        @gl.glDrawArrays(JavaImports::GL10::GL_TRIANGLE_STRIP, 0, 4)
      end
      @gl.glDisableClientState(JavaImports::GL10::GL_VERTEX_ARRAY) 
      if self[:render_state].tex_name == NO_TEXTURE
        @gl.glDisableClientState(JavaImports::GL10::GL_COLOR_ARRAY) 
      else
        @gl.glDisableClientState(JavaImports::GL10::GL_TEXTURE_COORD_ARRAY)        
      end  
    end
    
    def <=> other
      self.z <=> other.z
    end  
  end
end