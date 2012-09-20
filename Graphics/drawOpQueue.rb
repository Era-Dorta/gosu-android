module Gosu
  class DrawOpQueue
    def initialize
      @ops = []
    end
    
    def schedule_draw_op(op)
      #TODO Should do more stuff, check original code
      @ops.push op
    end
    
    def perform_draw_ops_and_code
      #Sort by z
      @ops.sort!
      @ops.each do |op|        
          op.perform(0) if op.vertices_or_block_index >= 0
      end
    end
    
    
    def clear_queue
      @ops = []
    end
    
  end
end