require 'gosu'
require 'chipmunk'

#Simple arkanoid copy that uses gosu and chipmunk
SUBSTEPS = 6

module ZOrder
  Hidden, Background, Block, Player, UI = *0..4
end


#Module where we define paths to the resources
module Resources
  if defined? Ruboto
    #On Android: use this paths
    Resources::BALL = Ruboto::R::drawable::yellow_square
    Resources::BEEP = Ruboto::R::raw::beep
    Resources::SONG = Ruboto::R::raw::chriss_onac_tempo_red
    Resources::BLOCK = Ruboto::R::drawable::block
    Resources::BLOCK_BROKEN = Ruboto::R::drawable::block_half_broken
    Resources::PLAYER = Ruboto::R::drawable::bar_hor
    Resources::BACKGROUND = Ruboto::R::drawable::arkanoid_background
  else
    #On PC: use this paths
    Resources::BALL = "media/yellow_square.png"
    Resources::BEEP = "media/beep.wav"
    Resources::SONG = "media/chriss_onac_tempo_red.mp3"
    Resources::BLOCK = "media/block.png" 
    Resources::BLOCK_BROKEN = "media/block_half_broken.png" 
    Resources::PLAYER = "media/bar_hor.png"
    Resources::BACKGROUND = "media/arkanoid_background.png"
  end
end


class Ball
  attr_reader :shape
  def initialize window, shape, file_name, x, y, z, size, velocity_x, velocity_y  
    @shape = shape
    @shape.body.p = CP::Vec2.new(x, y) # position
    @shape.body.v = CP::Vec2.new(velocity_x, velocity_y) # velocity   
    @z = z
    @image = Gosu::Image.new(window, file_name, false)  
  end
  
  #Every time there is a collision the ball must bounce    
  def bounce other_object
    #Calculate new velocity, after the hit  
    if other_object.type == :vertical
      #If the object was vertical change x velocity
      @shape.body.v.x = -@shape.body.v.x  
    else
      #If the object was horizontal change y velocity
      @shape.body.v.y = -@shape.body.v.y  
    end  
  end
  
  def validate_position
    #Check that the ball did not go under the screen
    if @shape.body.p.y > 480
      @shape.body.p.y = 200
      #Change y velocity so that the ball will not move in
      #the same direction as before
      @shape.body.v.y = -@shape.body.v.x       
    end  
  end
  
  def draw
    #Draw ball at current position
    @image.draw(@shape.body.p.x, @shape.body.p.y, @z)
  end
end

#Class for blocks and player
class StillObject
  attr_reader :type, :shape, :deletable
  attr_accessor :delete_count, :image
  def initialize(window, shape, file_name, x, y, z, type, deletable, delete_count = 1)
    @image = Gosu::Image.new(window, file_name)    
    @z = z
    @deletable = deletable #Indicates wheter we can delete this object or not  
    #Indicates the number of hits needed to delete this block
    @delete_count = delete_count
    @type = type #Vertical or horizontal
    @shape = shape
    @shape.body.p = CP::Vec2.new(x , y ) # position
    @shape.body.v = CP::Vec2.new(0, 0) # velocity    
  end
  
  def draw
    @image.draw(@shape.body.p.x, @shape.body.p.y, @z)
  end  
end

class GameWindow < Gosu::Window
  def initialize
    #Creates a window of 600 by 400, not fullscreen, at 30 fps
    super 600, 480, false, 30
    #Window title
    self.caption = "Gosu Arkanoid"
    @score = 0  
    @song = Gosu::Song.new(self, Resources::SONG)
    @beep = Gosu::Sample.new(self, Resources::BEEP)
    @background_image = Gosu::Image.new(self, Resources::BACKGROUND, true)
    @p1x = 0
    @stillObjects = Array.new
    # Time increment over which to apply a physics "step" ("delta t")
    @dt = self.update_interval/(1000.0*SUBSTEPS)
    #We need to define a space where the physics will take place
    @space = CP::Space.new   
    
    #Ball body, arguments for body new are mass and inertia
    ball_body = CP::Body.new(1.0, Float::MIN)
    
    #Shape, we define a square shape
    ball_shape_array = [CP::Vec2.new(-5.0, -5.0), CP::Vec2.new(-5.0, 5.0), CP::Vec2.new(5.0, 5.0), CP::Vec2.new(5.0, -5.0)]
    #Arguments are the body, the shape and an offset to be added to each vertex
    ball_shape = CP::Shape::Poly.new(ball_body, ball_shape_array, CP::Vec2.new(0,0))
    #Set a name for collisions
    ball_shape.collision_type = :ball
    #Add the body and the shape to the space
    @space.add_body(ball_body)
    @space.add_shape(ball_shape)    
    
    @ball = Ball.new(self, ball_shape, Resources::BALL, 100, 200, ZOrder::Block, 10, 300, 300)
    
    #Size of the image we are using for the blocks       
    @size = 80   
    new_block_body_shape CP::Vec2.new(1.0, 1.0), CP::Vec2.new(@size, 1.0) 
    @player = StillObject.new(self, @shape_block, Resources::PLAYER, 300, 423, ZOrder::Block, :horizontal, false)

    #Left plane
    new_block_body_shape CP::Vec2.new(1.0, 1.0), CP::Vec2.new(1.0, 480.0) 
    @p1 = StillObject.new(self, @shape_block,Resources::BLOCK, 0, 0, ZOrder::Hidden, :vertical, false)
    #Top plane
    new_block_body_shape CP::Vec2.new(1.0, 1.0), CP::Vec2.new(600.0, 1.0) 
    @p2 = StillObject.new(self, @shape_block,Resources::BLOCK, 0, 0, ZOrder::Hidden, :horizontal, false)
    #Right plane
    new_block_body_shape CP::Vec2.new(1.0, 1.0), CP::Vec2.new(1.0, 480.0) 
    @p3 = StillObject.new(self, @shape_block,Resources::BLOCK, 600, 0 , ZOrder::Hidden, :vertical, false)
    
    @blocks = []
    @blocks_position = []
    #Position for the first block
    block_x = 150
    block_y = 120
    img = Resources::BLOCK
    2.times do |i|
      3.times do |j|
        new_block_body_shape CP::Vec2.new(1.0, 1.0), CP::Vec2.new(@size, 1.0) 
        @blocks.push StillObject.new(self, @shape_block, img, block_x + (@size + 30)*i, block_y + 30*j , ZOrder::Block, :horizontal, true, 2)
        @stillObjects.push @blocks.last
      end
    end
    
    @stillObjects.push @p1, @p2, @p3, @player
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @song.play true
    
    @remove_shapes = []
    #Add method to be called when the ball hits anything
    @space.add_collision_func(:ball, :block) do |ball_shape, block_shape|
      #Search block_shape in stills obects, if is not found it means that the
      #ball already hit it and should be gone, but chipmunk was faster and it
      #generated another collision before it could be erased.   
      
      #Since we iterate several times in every frame only allow one
      #collision per frame, otherwise strange things will happen    
      if @allow_collision
        index = @stillObjects.index{|obj| obj.shape==block_shape}
        if(index != nil )  
          @beep.play
          @ball.bounce @stillObjects[index]        
          if(@stillObjects[index].deletable )  
            if( @stillObjects[index].delete_count <= 1)
              #Block can be deleted
              @score += 10  
              #Bodies and shapes cannot be deleted here so we mark them for later
              @remove_shapes << block_shape  
            else
              #Block cannot be deleted yet.
              #Decrease delete count
              @stillObjects[index].delete_count -= 1
              #Use half broken image to show it only needs one more hit to
              #be broken
              @stillObjects[index].image = Gosu::Image.new(self, Resources::BLOCK_BROKEN)
            end                         
          end    
        end
        @allow_collision = false    
      end          
    end        
  end
  
  #Creates a new body and shape for a block
  def new_block_body_shape pos0, pos1
    #Arguments for body new are mass and inertia
    body_block = CP::Body.new(Float::MAX, Float::MAX)
    @shape_block = CP::Shape::Segment.new(body_block, pos0, pos1, 0)
    
    @shape_block.collision_type = :block   
    @space.add_body(body_block)
    @space.add_shape(@shape_block)      
  end
  
  def update
    
    #Every frame iterate substeps times  
    SUBSTEPS.times do |i|
      @allow_collision = true
      #Delete the block body and shape from the space
      @remove_shapes.each do |shape|         
        @blocks.delete_if { |block| block.shape == shape }
        @stillObjects.delete_if { |obj| obj.shape == shape }
        @space.remove_body(shape.body)
        @space.remove_shape(shape)
      end     
      
      @remove_shapes.clear  
      #Check the ball current position    
      @ball.validate_position      
      #Move the objects in the world one dt
      @space.step(@dt)          
    end  

    #On PC: if player press 'A' key, move left
    if button_down? Gosu::KbA then
      if @player.shape.body.p.x > 0
        @player.shape.body.p.x -= 10
      end  
    end  

    #On PC: if player press 'D' key, move right
    if button_down? Gosu::KbD then
      if @player.shape.body.p.x + @size < 600
        @player.shape.body.p.x += 10
      end
    end 
    
  end
 
  #On Android use touches
  def touch_moved(touch)
    #On a touch interface translate directly the player's position
    @player.shape.body.p.x = touch.x
  end
  
  #On PC: If player pressed escape then close the game
  def button_down(id) 
    if id == Gosu::KbEscape then
      close
    end
  end  
  
  #Draw the blocks, tha player, the ball and the current score
  def draw
    @background_image.draw(0, 0, ZOrder::Background)
    
    @blocks.each do |b|
      b.draw
    end
    
    @ball.draw
    @player.draw
    @font.draw("Score: #{@score}", 10, 10, ZOrder::UI, 1.0, 1.0, 0xffffff00)
  end
 
end

if not defined? Ruboto
  #On PC: do standard initialization
  window = GameWindow.new
  window.show 
else
  #On Android: do more complex initialization
  class Arkanoid2Activity
    def on_create(bundle)
      super(bundle)
      #Start initializer
      Gosu::AndroidInitializer.instance.start(self)
      rescue Exception => e
        puts "#{ e } (#{ e.class } #{e.message} #{e.backtrace.inspect} )!"    
    end  
    
    #Initializer will call this method when it is ready
    def on_ready
      window = GameWindow.new
      window.show   
      rescue Exception => e
        puts "#{ e } (#{ e.class } #{e.message} #{e.backtrace.inspect} )!"    
    end
  end  
end
