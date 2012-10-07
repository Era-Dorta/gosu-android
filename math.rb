module Gosu
  
  def self.offset_x(angle, radius)
    Math::sin(angle / 180 * Math::PI) * radius
  end
  
  def self.offset_y(angle, radius)
    Math::cos(angle / 180 * Math::PI) * radius
  end
    
end