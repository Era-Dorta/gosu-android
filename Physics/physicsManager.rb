require 'physicsObject'

module Gosu
  
  class PhysicsManager
    
    def initialize(window, gravity = 9.8)
      @dt = @window.update_interval
      @gravity = gravity
      @squares = []
      @planes = []
      @window = window
    end
    
    def register_new_object object
      if object.class == Square
        @squares.push object
      elsif
        @planes.push object
      end
    end
    
    def update
      #Gravity
      @squares.each do |square| 
        if square.mass_inverted > 0
          square.velocity[1] += @dt*@gravity
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
    
    def draw
      @squares.each do |square|
        square.draw
      end
    end
    
  end  
  
end