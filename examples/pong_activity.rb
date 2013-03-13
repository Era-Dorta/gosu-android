require 'gosu'

class GameWindow < Gosu::Window
  def initialize
    super 600, 480, false, 50
    self.caption = "Gosu Pong Game"
    self.physics_manager.gravity_y = 0
    @p1score = 0
    @p2score = 0  
    @song = Gosu::Song.new(self, Ruboto::R::raw::chriss_onac_tempo)
    @beep = Gosu::Sample.new(self, Ruboto::R::raw::beep)
    @p1x = 0
    # 25 is to compesate square size of the ball
    @p1y = 250 + 25
    @p3x = 593
    @p3y = 100 + 25
    @size = 110
    @size2 = @size/2 - 25
    @squ = Gosu::Square.new(self, Ruboto::R::drawable::ball, 100, 200, 0, 50, 20, 100, 100)
    #Left plane
    @p1 = Gosu::Plane.new(self, Ruboto::R::drawable::bar, [@p1x,@p1y], [@p1x, @p1y + @size] ,0)
    #Top plane
    @p2 = Gosu::Plane.new(self, Ruboto::R::drawable::bar, [600,0], [0,0], 0 )
    #Right plane
    @p3 = Gosu::Plane.new(self,Ruboto::R::drawable::bar, [@p3x,@p3y + @size], [@p3x,@p3y], 0)
    #Bottom plane
    @p4 = Gosu::Plane.new(self,Ruboto::R::drawable::bar, [0,480], [600,480],  0)
    self.apply_physics @squ
    self.apply_physics @p1
    self.apply_physics @p2
    self.apply_physics @p3
    self.apply_physics @p4
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @song.play true
  end

  def update
    if @squ.center[0] < 0
      #Player 1 lost
      @p1score += 1
      #Reset the ball
      @squ.position[0] = 300
      @squ.velocity[0] = -@squ.velocity[0]
      @beep.play
    else
      if @squ.center[0] > 600
        #Player2 lost
        @p2score += 1
        #Reset the ball
        @squ.position[0] = 300
        @squ.velocity[0] = -@squ.velocity[0]
        @beep.play
      end
    end  
  end
  
  def object_collided( x, y, other_object ) 
    @beep.play
  end 

  def touch_moved(touch)
    touch.y = touch.y - @size2
    if touch.x < 300
      #Player1
      @p1y = touch.y
      @p1.bottom_limit[1] = @p1y + @size
      @p1.top_limit[1] = @p1y  
    else
      #Player2
      @p3y = touch.y
      @p3.bottom_limit[1] = @p3y + @size  
      @p3.top_limit[1] =  @p3y     
    end
  end
  
  def draw
    @squ.draw
    @p1.draw(@p1x,@p1y,0)
    @p3.draw(@p3x,@p3y,0)
    @font.draw("Score: p1 #{@p1score} p2#{@p2score} ", 10, 10, 3, 1.0, 1.0, 0xffffff00)
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
