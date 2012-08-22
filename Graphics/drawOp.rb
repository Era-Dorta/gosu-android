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
      #TODO change color
      @gl.glColor4f(0.0, 1.0, 0.0, 0.5)      
      #TODO Read vector nice
      vector = []
      vector.push self[:vertices][0].x
      vector.push self[:vertices][0].y
      vector.push self[:z]
      vector.push self[:vertices][1].x
      vector.push self[:vertices][1].y 
      vector.push self[:z]  
    
      vbb = JavaImports::ByteBuffer.allocateDirect(vector.length*4)
      vbb.order(JavaImports::ByteOrder.nativeOrder)
      vertex_buffer = vbb.asFloatBuffer
      #TODO Put all vertex, not just first on
      vertex_buffer.put(vector.to_java(:float))
      vertex_buffer.position(0)
      
      case self[:verticesOrBlockIndex]
      when 2
        @gl.glVertexPointer(3, JavaImports::GL10::GL_FLOAT, 0, vertex_buffer)
        @gl.glDrawArrays(JavaImports::GL10::GL_LINE_STRIP, 0, 2) 
        @gl.glDisableClientState(JavaImports::GL10::GL_VERTEX_ARRAY)        
      when 3
        
      when 4
      end
    end
    
    def <=> other
      self.z <=> other.z
    end  
  end
end