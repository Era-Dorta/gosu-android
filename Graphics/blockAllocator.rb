module Gosu
  class BlockAllocator
    private
    class Impl < Struct.new(:width, :height, :blocks, :first_x, :first_y, :max_w, :max_h)
      
      def mark_block_used
      end
      
      def is_block_free
      end
        
    end
    
    public
    class Block < Struct.new(:left, :top, :width, :height); end
        
    def initialize(width, height)
      @pimpl = Impl.new(width, height, nil, 0, 0, width, height)
    end
    
    def width
      @pimpl.width
    end
    
    def height
      @pimpl.height
    end
    
    def alloc(a_width, a_height)
      #The rect wouldn't even fit onto the texture!
      if a_width > width || a_height > height
          return [false]
      end     
    #We know there's no space left.
    if a_width > @pimpl.max_w && a_height > @pimpl.max_h
        return false
    end
    #Start to look for a place next to the last returned rect. Chances are
    #good we'll find a place there.
    b = Block.new(@pimpl.first_x, @pimpl.first_y, a_width, a_height)
    if @pimpl.is_block_free(b)
      @pimpl.mark_block_used(b, a_width, a_height)
      return true
    end

    #Brute force: Look for a free place on this texture.
    x = b.left
    y = b.top
    #TODO Change for loops into some rubish stuff
    for(y = 0, y <= height - a_height, y += 16) do
        for(x = 0, x <= width - a_width, x += 8) do
        
            if not @pimpl.is_block_free(b)
                continue
            end
            #Found a nice place!

            #Try to make up for the large for()-stepping.
            while (y > 0 and @pimpl.is_block_free(Block.new(x, y - 1, a_width, a_height)))
                y -= 1
            while (x > 0 and @pimpl.is_block_free(Block.new(x - 1, y, a_width, a_height)))
                x -= 1
            
            @pimpl.mark_block_used(b, a_width, a_height)
            return true
        end
    end
    #So there was no space for the bitmap. Remember this for later.
    @pimpl.max_w = a_width - 1
    @pimpl.max_h = a_height - 1
    return false           
    end
    
  end
end