require 'gosu_android/graphics/renderState'

module Gosu
  class DrawOpQueue
    attr_reader :op_pool
    def initialize(gl)
      @ops = []
      @gl = gl
      @op_pool = DrawOpPool.new(@gl, 50)
    end

    def gl= gl
      @gl = gl
    end

    def schedule_draw_op(op)
      #TODO Should do more stuff, check original code
      @ops.push op
    end

    def perform_draw_ops_and_code
      #Sort by z
      @ops.sort!
      manager = RenderStateManager.new(@gl)
      @ops.each do |op|
          manager.render_state = op.render_state
          op.perform(nil) if op.vertices_or_block_index >= 0
      end
      @op_pool.clearPool
    end


    def clear_queue
      @ops.clear
      @op_pool.clearPool
    end

  end
end
