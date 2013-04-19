require 'gosu'
require 'chipmunk'

SUBSTEPS = 6

module Resources
  if defined? Ruboto
    Resources::BALL = Ruboto::R::drawable::yellow_square
    Resources::BEEP = Ruboto::R::raw::beep
    Resources::SONG = Ruboto::R::raw::chriss_onac_tempo_red
    Resources::BLOCK = Ruboto::R::drawable::bar
  else
    Resources::BALL = "media/yellow_square.png"
    Resources::BEEP = "media/beep.wav"
    Resources::SONG = "media/chriss_onac_tempo_red.mp3"
    Resources::BLOCK = "media/bar_hor.png" 
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
      
  def bounce other_object
    #Calculate new velocity, after the hit
    if other_object.type == :vertical
      @shape.body.v.x = -@shape.body.v.x  
    else
      @shape.body.v.y = -@shape.body.v.y  
    end  
  end
  
  def validate_position
    #Check that the ball did not go under the screen
    if @shape.body.p.y > 480
      @shape.body.p.y = 200
      @shape.body.v.y = -@shape.body.v.x       
    end  
  end
  
  def draw
    @image.draw(@shape.body.p.x, @shape.body.p.y, @z)
  end
end

class StillObject
  attr_reader :type, :shape, :deletable
  def initialize(window, shape, file_name, x, y, z, type, deletable)
    @image = Gosu::Image.new(window, file_name)    
    @z = z
    @deletable = deletable
    @type = type
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
    super 600, 480, false, 30
    self.caption = "Gosu Arkanoid"
    @score = 0  
    @song = Gosu::Song.new(self, Resources::SONG)
    @beep = Gosu::Sample.new(self, Resources::BEEP)
    @p1x = 0
    @stillObjects = Array.new
    # Time increment over which to apply a physics "step" ("delta t")
    @dt = self.update_interval/(1000.0*SUBSTEPS)
    @space = CP::Space.new   
    
    #Ball body, rguments for body new are mass and inertia
    ball_body = CP::Body.new(1.0, 150.0)
    
    #Shape, we define a square shape
    ball_shape_array = [CP::Vec2.new(-5.0, -5.0), CP::Vec2.new(-5.0, 5.0), CP::Vec2.new(5.0, 5.0), CP::Vec2.new(5.0, -5.0)]
    #Arguments are the body, the shape and an offset to be added to each vertex
    ball_shape = CP::Shape::Poly.new(ball_body, ball_shape_array, CP::Vec2.new(0,0))
    #Set a name for collisions
    ball_shape.collision_type = :ball
    #Add the body and the shape to the space
    @space.add_body(ball_body)
    @space.add_shape(ball_shape)    
    
    @ball = Ball.new(self, ball_shape, Resources::BALL, 100, 200, 0, 10, 100, 100)
    
    #Size of the image we are using for the blocks       
    @size = 110   
    new_block_body_shape CP::Vec2.new(1.0, 1.0), CP::Vec2.new(@size, 1.0) 
    @player = StillObject.new(self, @shape_block, Resources::BLOCK, 300, 473,  0, :horizontal, false)

    #Left plane
    new_block_body_shape CP::Vec2.new(1.0, 1.0), CP::Vec2.new(1.0, 480.0) 
    @p1 = StillObject.new(self, @shape_block,Resources::BLOCK, 0, 0, 0, :vertical, false)
    #Top plane
    new_block_body_shape CP::Vec2.new(1.0, 1.0), CP::Vec2.new(600.0, 1.0) 
    @p2 = StillObject.new(self, @shape_block,Resources::BLOCK, 0, 0, 0, :horizontal, false)
    #Right plane
    new_block_body_shape CP::Vec2.new(1.0, 1.0), CP::Vec2.new(1.0, 480.0) 
    @p3 = StillObject.new(self, @shape_block,Resources::BLOCK, 600, 0 , 0, :vertical, false)
    
    @blocks = []
    @blocks_position = []
    block_x = 150
    block_y = 120
    img = Resources::BLOCK
    2.times do |i|
      3.times do |j|
        new_block_body_shape CP::Vec2.new(1.0, 1.0), CP::Vec2.new(@size, 1.0) 
        @blocks.push StillObject.new(self, @shape_block, img, block_x + (@size + 30)*i, block_y + 30*j ,  0, :horizontal, true)
        @stillObjects.push @blocks.last
      end
    end
    
    @stillObjects.push @p1, @p2, @p3, @player
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @song.play true
    
    @remove_shapes = []
    @space.add_collision_func(:ball, :block) do |ball_shape, block_shape|
      #Search block_shape in stills obects, if is not found it means that the
      #ball already hit it and should be gone, but chipmunk was faster and it
      #generated another collision before it could be erased. 
      index = @stillObjects.index{|obj| obj.shape==block_shape}
      if(index != nil )  
        @beep.play
        @ball.bounce @stillObjects[index]        
        if(@stillObjects[index].deletable )  
          @score += 10  
          #Bodies and shapes cannot be deleted here so we mark them for later
          @remove_shapes << block_shape
          @blocks.delete @stillObjects[index] 
          @stillObjects.delete_at index                           
        end    
      end    
    end        
  end
  
  #Creates a new body and shape for a block
  def new_block_body_shape pos0, pos1
    #Arguments for body new are mass and inertia
    @body_block = CP::Body.new(10.0, 150.0)
    @shape_block = CP::Shape::Segment.new(@body_block, pos0, pos1, 0)
    
    @shape_block.collision_type = :block   
    @space.add_body(@body_block)
    @space.add_shape(@shape_block)      
  end
  
  def update
      
    SUBSTEPS.times do
      #Delete the block body and shape from the space
      @remove_shapes.each do |shape|
        @space.remove_body(shape.body)
        @space.remove_shape(shape)
      end     
      
      @remove_shapes.clear  
      #Check the ball current position    
      @ball.validate_position      
      #Move the objects in the world one dt
      @space.step(@dt)          
    end  

    if button_down? Gosu::KbA then
      if @player.shape.body.p.x > 0
        @player.shape.body.p.x -= 10
      end  
    end  

    if button_down? Gosu::KbD then
      if @player.shape.body.p.x + @size < 600
        @player.shape.body.p.x += 10
      end
    end 
    
  end
 
  def touch_moved(touch)
    #On a touch interface translate directly the player's position
    @player.shape.body.p.x = touch.x
  end
  
  def button_down(id) 
    if id == Gosu::KbEscape then
      close
    end
  end  
  
  def draw
    @blocks.each_index do |i|
      @blocks[i].draw
    end
    
    @ball.draw
    @player.draw
    @font.draw("Score: #{@score}", 10, 10, 3, 1.0, 1.0, 0xffffff00)
  end
 
end

if not defined? Ruboto
  window = GameWindow.new
  window.show 
else
  class TutorialCommonActivity
    def on_create(bundle)
      super(bundle)
      Gosu::AndroidInitializer.instance.start(self)
      rescue Exception => e
        puts "#{ e } (#{ e.class } #{e.message} #{e.backtrace.inspect} )!"    
    end  
    
    def on_ready
      window = GameWindow.new
      window.show  
      window.show_soft_keyboard  
      rescue Exception => e
        puts "#{ e } (#{ e.class } #{e.message} #{e.backtrace.inspect} )!"    
    end
  end  
end
