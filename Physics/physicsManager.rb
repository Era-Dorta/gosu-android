require 'physicsObject'

module Gosu
  
  class PhysicsManager
    attr_accessor :gravity_x, :gravity_y
    def initialize(window)
      @window = window
      @dt = @window.update_interval
      @squares = []
      @planes = []      
      @gravity_x = 0
      @gravity_y = 98 #10 pixels are 1 meter
    end
    
    def register_new_object object
      if object.class == Square
        @squares.push object
      elsif
        @planes.push object
      end
    end

    def delete_object object 
      if object.class == Square
        @squares.delete object
      elsif
        @planes.delete object
      end
    end
        
    def update
      #Gravity
      @squares.each do |square| 
        if square.mass_inverted > 0
          square.velocity[0] += @dt*@gravity_x
          square.velocity[1] += @dt*@gravity_y
        end 
      end
      
     #Collision detection
     @squares.each do |square|
       @planes.each do |plane| 
         square.generate_contact plane 
       end   
     end

     #Integrate
      @squares.each do |square|
        if square.mass_inverted > 0
          square.integrate
        end 
      end        
    end    
  end  
  
end