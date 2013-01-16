module Gosu
  
  def self.offset_x(angle, radius)
    Math::sin(angle / 180 * Math::PI) * radius
  end
  
  def self.offset_y(angle, radius)
    Math::cos(angle / 180 * Math::PI) * radius
  end
  
  #Returns the square of the distance between two points.
  def self.distance_sqr(x1, y1, x2, y2)
    (x1 - x2)**2 + (y1 - y2)**2
  end
    
  #Returns the distance between two points.
  def self.distance(x1, y1, x2, y2)
    Math::sqrt((x1 - x2)**2 + (y1 - y2)**2)
  end    
  
end