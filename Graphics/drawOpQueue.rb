require 'renderState'

module Gosu
  class DrawOpQueue
    def initialize(gl)
      @ops = []
      @gl = gl
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
          op.perform(0) if op.vertices_or_block_index >= 0
      end
    end
    
    
    def clear_queue
      @ops = []
    end
    
  end
end