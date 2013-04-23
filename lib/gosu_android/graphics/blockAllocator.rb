module Gosu
  class BlockAllocator
    private
    class Impl < Struct.new(:width, :height, :blocks, :first_x, :first_y, :max_w, :max_h)
      alias :old_initialize :initialize
      
      def initialize(*args)      
        old_initialize *args
        if self[:blocks] == nil
          self[:blocks] = Array.new
        end  
      end   
      
      def mark_block_used(block, a_width, a_height)
        self[:first_x] += a_width
        if (self[:first_x] + a_width) >= self[:width]
          self[:first_x] = 0
          self[:first_y] += a_height
        end
        self[:blocks].push block     
      end
      
      def is_block_free(block)
        #(The right-th column and the bottom-th row are outside of the block.)
        right = block.left + block.width
        bottom = block.top + block.height

        #Block isn't valid.
        if (right > self[:width] || bottom > self[:height])
            return false
        end
        
        #Test if the block collides with any existing rects.
        self[:blocks].each do |i|
            if (i.left < right and block.left < i.left + i.width and
                i.top < bottom and block.top < i.top + i.height)
                return false
            end
        end
        true  
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
          return [false]
      end
      #Start to look for a place next to the last returned rect. Chances are
      #good we'll find a place there.
      b = Block.new(@pimpl.first_x, @pimpl.first_y, a_width, a_height)
      if @pimpl.is_block_free(b)
        @pimpl.mark_block_used(b, a_width, a_height)
        return [true, b]
      end

      b.top = 0
      b.left = 0
      #Brute force: Look for a free place on this texture.
      while(b.top <= (height - a_height)) do 
        while(b.left <= (width - a_width)) do
          if @pimpl.is_block_free(b)
            #Found a nice place!
  
            #Try to make up for the large for()-stepping.
            while (b.top > 0 and @pimpl.is_block_free(Block.new(b.left, b.top - 1, a_width, a_height))) do
                b.top -= 1
            end    
            while (b.left > 0 and @pimpl.is_block_free(Block.new(b.left - 1, b.top, a_width, a_height))) do
                b.left -= 1
            end
            @pimpl.mark_block_used(b, a_width, a_height)
            return [true, b]          
          end
          b.top += 16
          b.left += 8
        end      
      end
    
      #So there was no space for the bitmap. Remember this for later.
      @pimpl.max_w = a_width - 1
      @pimpl.max_h = a_height - 1
      return [false]           
    end
    
    def free (left, top)
      @pimpl.blocks.delete_if do |block|
        if block.left == left and block.top == top
          @pimpl.max_w = @pimpl.max_w - 1
          @pimpl.max_h = @pimpl.max_h - 1
          true
        else
          false  
        end
      end
    end
    
  end
end