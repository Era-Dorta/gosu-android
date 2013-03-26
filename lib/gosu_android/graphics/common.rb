module Gosu
  NO_TEXTURE = -1
  NO_CLIPPING = 0xffffffff
  #In various places in Gosu, width==NO_CLIPPING conventionally means
  #that no clipping should happen.  
  java_import 'gosu.java.ClipRect'

  def self.is_p_to_the_left_of_ab(xa, ya, xb, yb, xp, yp)
    ((xb - xa) * (yp - ya) - (xp - xa) * (yb - ya)) > 0
  end       
  
  def self.reorder_coordinates_if_necessary(x1, y1, x2, y2, x3, y3, c3, x4, y4, c4)
    if (Gosu::is_p_to_the_left_of_ab(x1, y1, x2, y2, x3, y3) ==
      Gosu::is_p_to_the_left_of_ab(x2, y2, x3, y3, x4, y4))
      true
    else
      false
    end    
  end
    
end