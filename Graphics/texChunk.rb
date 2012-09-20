require 'imageData'
require 'texRequires'
require 'common'

module Gosu
  class TexChunk < ImageData
    def initialize(graphics, queues, texture, x, y, w, h, padding)
      #Define object destructor
      ObjectSpace.define_finalizer(self,
                    self.class.method(:finalize).to_proc) 
      @graphics = graphics
      @queues = queues
      @texture = texture
      @x = x
      @y = y
      @w = w
      @h = h
      @padding = padding
      @info = GlTexInfo.new
      @info.tex_name = @texture.name
      #Force float division
      @info.left = @x.to_f / @texture.size
      @info.top = @y.to_f / @texture.size
      @info.right = (@x.to_f + @w) / @texture.size
      @info.bottom = (@y.to_f + @h) / @texture.size   
    end
    
    def TexChunk.finalize(id)
      @texture.free(@x - @padding, @y - @padding)
    end
    
    def width
      @w
    end
    
    def height
      @h
    end
    
    def draw( x1,  y1,  c1, x2,  y2,  c2, x3,  y3,  c3, x4,  y4,  c4, z, mode)
      op = DrawOp.new(@graphics.gl)
      op.render_state.tex_name = @info.tex_name
      op.renderState.mode = mode
      
      if reorder_coordinates_if_necessary(x1, y1, x2, y2, x3, y3, c3, x4, y4, c4)
        x3, y3, c3, x4, y4, c4 = x4, y4,c4, x3, y3, c3
      end  
      op.vertices_or_block_index = 4
      #TODO Reorder in case does not work
      op.vertices[0] = DrawOp::Vertex.new(x1, y1, c1)
      op.vertices[1] = DrawOp::Vertex.new(x2, y2, c2)
      op.vertices[3] = DrawOp::Vertex.new(x3, y3, c3)
      op.vertices[2] = DrawOp::Vertex.new(x4, y4, c4)
      
      op.left = @info.left
      op.top = @info.top
      op.right = @info.right
      op.bottom = @info.bottom
      
      op.z = z
      @queues.schedule_draw_op(op)   
    end  
        
    def glTexInfo
      @info
    end
    
    def to_bitmap; end      
  end
end