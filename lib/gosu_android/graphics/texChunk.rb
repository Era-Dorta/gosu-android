require 'gosu_android/graphics/imageData'
require 'gosu_android/graphics/common'

module Gosu
  class TexChunk < ImageData
    def initialize(graphics, queues, texture, x, y, w, h, padding)
      @graphics = graphics
      @queues = queues
      @texture = texture
      #Define object destructor
      ObjectSpace.define_finalizer(self, Proc.new{@texture.finalize})
      @x = x
      @y = y
      @w = w
      @h = h
      @padding = padding
      @info = GLTexInfo.new
      @info.tex_name = @texture.tex_name
      #Force float division
      @info.left = @x.to_f / @texture.size
      @info.top = @y.to_f / @texture.size
      @info.right = (@x.to_f + @w) / @texture.size
      @info.bottom = (@y.to_f + @h) / @texture.size
    end

    def finalize
      @texture.free(@x - @padding, @y - @padding)
    end

    def width
      @w
    end

    def height
      @h
    end

    def draw( x1,  y1,  c1, x2,  y2,  c2, x3,  y3,  c3, x4,  y4,  c4, z, mode)
      op = @queues.op_pool.newDrawOp
      op.render_state.tex_name = @info.tex_name
      op.render_state.mode = mode

      if Gosu::reorder_coordinates_if_necessary(x1, y1, x2, y2, x3, y3, c3, x4, y4, c4)
        x3, y3, c3, x4, y4, c4 = x4, y4,c4, x3, y3, c3
      end
      op.vertices_or_block_index = 4
      op.vertices[0].set(x1, y1, c1)
      op.vertices[1].set(x2, y2, c2)
      op.vertices[2].set(x3, y3, c3)
      op.vertices[3].set(x4, y4, c4)

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
