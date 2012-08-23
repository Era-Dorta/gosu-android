require 'renderState'

module Gosu
  class DrawOp < Struct.new(:z, :verticesOrBlockIndex, :top, :left, :bottom, :right, :renderState, :vertices)  
    
    class Vertex < Struct.new(:x, :y, :c); end  
    
    def initialize(gl)
      @gl = gl  
      self[:vertices] = Array.new
      self[:renderState] = RenderState.new
    end
    
    def perform(nextOp)
      if self[:verticesOrBlockIndex] < 2 or self[:verticesOrBlockIndex] > 4
        raise "Wrong verticesOrBlockIndex"
      end
      @gl.glEnableClientState(JavaImports::GL10::GL_VERTEX_ARRAY) 
      @gl.glEnableClientState(JavaImports::GL10::GL_COLOR_ARRAY)
      
      color = []
      index = []
      self[:vertices].each do |vertex|
        color.push vertex.c.red
        color.push vertex.c.green
        color.push vertex.c.blue
        color.push vertex.c.alpha
        
        index.push vertex.x
        index.push vertex.y
        index.push self[:z]
      end

      cbb = JavaImports::ByteBuffer.allocateDirect(color.length*4)
      cbb.order(JavaImports::ByteOrder.nativeOrder)
      color_buffer = cbb.asFloatBuffer
      color_buffer.put(color.to_java(:float))
      color_buffer.position(0)                
    
      vbb = JavaImports::ByteBuffer.allocateDirect(index.length*4)
      vbb.order(JavaImports::ByteOrder.nativeOrder)
      vertex_buffer = vbb.asFloatBuffer
      vertex_buffer.put(index.to_java(:float))
      vertex_buffer.position(0)
      
      case self[:verticesOrBlockIndex]
      when 2
        @gl.glColorPointer(4, JavaImports::GL10::GL_FLOAT, 0, color_buffer) 
        @gl.glVertexPointer(3, JavaImports::GL10::GL_FLOAT, 0, vertex_buffer)
        @gl.glDrawArrays(JavaImports::GL10::GL_LINE_STRIP, 0, 2) 
        @gl.glDisableClientState(JavaImports::GL10::GL_VERTEX_ARRAY) 
        @gl.glDisableClientState(JavaImports::GL10::GL_COLOR_ARRAY)       
      when 3
        
      when 4
      end
    end
    
    def <=> other
      self.z <=> other.z
    end  
  end
end