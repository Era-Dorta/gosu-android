module Gosu
  NO_TEXTURE = -1
  NO_CLIPPING = 0xffffffff
  #In various places in Gosu, width==NO_CLIPPING conventionally means
  #that no clipping should happen.  
  class ClipRect < Struct.new(:x, :y, :width, :height)
    def == other
      #No clipping
      (self[:width] == NO_CLIPPING && other.width == NO_CLIPPING) ||
        #Clipping, but same
        (self[:x] == other.x && self[:y] == other.y && 
          self[:width] == other.width && self[:height] == other.height)
    end
  end 
  
  def reorder_coordinates_if_necessary(x1, y1, x2, y2, x3, y3, c3, x4, y4, c4)
    if (isPToTheLeftOfAB(x1, y1, x2, y2, x3, y3) ==
      isPToTheLeftOfAB(x2, y2, x3, y3, x4, y4))
      true
    else
      false
    end    
  end
end