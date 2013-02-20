require 'image'

module Gosu

  def self.dot_product(l1, l2)
    sum = 0
    for i in 0...l1.size
        sum += l1[i] * l2[i]
    end
    sum
  end
  
  class Square
    attr_accessor :draw, :velocity
    attr_reader :position
    attr_reader :mass_inverted, :restitution 
    def initialize(window, file_name, x, y, z, size, mass_inverted, 
      velocity_x = 0, velocity_y = 0, restitution = 1, draw = true, tileable = false)
      @window = window
      @position = [x,y]
      @size = size / 2
      @center = [@position[0] + @size, @position[1] + @size] 
      @z = z
      @draw = draw
      @restitution = restitution
      @velocity = [velocity_x, velocity_y]
      @mass_inverted = mass_inverted
      @image = Gosu::Image.new(@window, file_name , tileable)
      @dt = @window.update_interval
    end

    def integrate
      @position[0] += @velocity[0]*@dt 
      @position[1] += @velocity[1]*@dt 
      @center = [@position[0] + @size, @position[1] + @size]
    end
    
    def generate_contact other_object
      if other_object.class == Square
      elsif other_object.class == Plane
        #Calculate distance to current plane
        distance = Gosu::dot_product(@center, other_object.normal) + other_object.normal[2]
        product = Gosu::dot_product(@velocity, other_object.normal)
        #If distance is less thant zero and the object 
        #is moving towards the plane        
        if distance < @size and product < 0
          #Calculate new velocity, after the hit          
          @velocity[0] -= (1 + @restitution) * other_object.normal[0] * product
          @velocity[1] -= (1 + @restitution) * other_object.normal[1] * product 
          #Call window event
          @window.object_collided( @position[0], @position[1], other_object )
        end
      end
    end
    
    def draw
      @image.draw(@position[0], @position[1], @z)
    end
        
  end

  class Plane
    attr_accessor :draw
    attr_reader :normal, :velocity, :mass_inverted 
    def initialize(window, a, b, c, mass_inverted = 0, 
      velocity_x = 0, velocity_y = 0, draw = false)
      @window = window
      @normal = [a,b,c]
      @draw = draw
      @velocity = [velocity_x, velocity_y]
      @mass_inverted = mass_inverted
      @dt = @window.update_interval
    end

    def integrate
      @position[0] += @velocity[0]*@dt 
      @position[1] += @velocity[1]*@dt 
    end
        
  end

end