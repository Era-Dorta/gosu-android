require 'gosu'

class GameWindow < Gosu::Window
  def initialize
    super 600, 480, false, 30
    self.caption = "Gosu Arkanoid"
    self.physics_manager.gravity_y = 0
    @score = 0  
    @song = Gosu::Song.new(self, Ruboto::R::raw::chriss_onac_tempo_red)
    @beep = Gosu::Sample.new(self, Ruboto::R::raw::beep)
    @p1x = 0

    @ball = Gosu::Square.new(self, Ruboto::R::drawable::ball, 100, 200, 0, 50, 20, 100, 100)

    @player_x = 300
    @player_y = 473    
    @size = 110
    # 25 is to compesate square size of the ball
    @size2 = @size/2 - 25    
    @player = Gosu::Plane.new(self,Ruboto::R::drawable::bar_hor, [@player_x, @player_y], [@player_x + @size, @player_y],  0)

    #Left plane
    @p1 = Gosu::Plane.new(self, Ruboto::R::drawable::bar, [0, 0], [0, 480], 0)
    #Top plane
    @p2 = Gosu::Plane.new(self, Ruboto::R::drawable::bar, [600, 0], [0, 0], 0)
    #Right plane
    @p3 = Gosu::Plane.new(self,Ruboto::R::drawable::bar, [600, 480], [600, 0], 0)
    
    @blocks = []
    @blocks_position = []
    block_x = 150
    block_y = 120
    img = Ruboto::R::drawable::bar_hor
    2.times do |i|
      3.times do |j|
        @blocks.push Gosu::Plane.new(self, img, [block_x + (@size + 30)*i , block_y + 30*j ], [block_x + (@size + 30)*(i + 1), block_y + 30*j ],  0)
        @blocks_position.push [block_x + (@size + 30)*i, block_y + 30*j]
        self.apply_physics @blocks[i]
      end
    end
    
    self.apply_physics @ball
    self.apply_physics @player
    self.apply_physics @p1
    self.apply_physics @p2
    self.apply_physics @p3
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @song.play true
  end

  def update
    if @ball.center[1] > 480
        @ball.position[1] = 200
        @ball.velocity[1] = -@ball.velocity[0]
        @beep.play      
    end
  end
 
  def object_collided( x, y, other_object ) 
    if(@blocks.include? other_object )      
      @score += 1
      self.stop_physics other_object
      @blocks_position.delete_at(@blocks.index other_object)
      @blocks.delete other_object
    end
    @beep.play
  end 

  def touch_moved(touch)
    touch.y = touch.y - @size2
    @player_x = touch.x
    @player.bottom_limit[0] = @player_x 
    @player.top_limit[0] = @player_x + @size
  end
  
  def draw
    @blocks.each_index do |i|
      @blocks[i].draw(@blocks_position[i][0], @blocks_position[i][1], 0)
    end
    
    @ball.draw
    @player.draw(@player_x, @player_y, 0)
    @font.draw("Score: #{@score}", 10, 10, 3, 1.0, 1.0, 0xffffff00)
  end
 
end

class GosuActivity
  def on_create(bundle)
    super(bundle)
    Gosu::AndroidInitializer.instance.start(self)
    rescue Exception => e
      puts "#{ e } (#{ e.class } #{e.message} #{e.backtrace.inspect} )!"    
  end  
  
  def on_ready
    window = GameWindow.new
    window.show    
    rescue Exception => e
      puts "#{ e } (#{ e.class } #{e.message} #{e.backtrace.inspect} )!"    
  end
end
