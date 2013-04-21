require 'gosu'

class Ball
    attr_accessor :velocity
    attr_reader :position, :center
  def initialize window, file_name, x, y, z, size, velocity_x, velocity_y
    @position = [x,y]
    @size = size / 2
    @center = [@position[0] + @size, @position[1] + @size]
    @z = z
    @velocity = [velocity_x, velocity_y]
    @image = Gosu::Image.new(window, file_name, false)
    @dt = window.update_interval/1000.0
  end
  
  def update
    @position[0] += @velocity[0]*@dt
    @position[1] += @velocity[1]*@dt
    @center[0] = @position[0] + @size
    @center[1] = @position[1] + @size
  end
  
  def generate_contact other_object
    if @center[0] - @size < other_object.top_limit[0] and other_object.bottom_limit[0] < @center[0] + @size and
      @center[1] - @size < other_object.bottom_limit[1] and other_object.top_limit[1] < @center[1] + @size
      #Calculate new velocity, after the hit
      if other_object.type == :vertical
        @velocity[0] -= 2 * @velocity[0]
      else
        @velocity[1] -= 2 * @velocity[1]
      end
      return true
    end
    return false
  end
  
  def draw
    @image.draw(@position[0], @position[1], @z)
  end
end

class StillObject
  attr_accessor :bottom_limit, :top_limit
  attr_reader :type
  def initialize(window, file_name, p0, p1, z)
    @image = Gosu::Image.new(window, file_name)
    @z = z
    @top_limit = Array.new p0
    @bottom_limit = Array.new p1
  
    if(@bottom_limit[0] > @top_limit[0] or @bottom_limit[1] < @top_limit[1])
      @top_limit, @bottom_limit = @bottom_limit, @top_limit
    end
  
    if @bottom_limit[0] == @top_limit[0]
      @type = :vertical
    elsif @bottom_limit[1] == @top_limit[1]
      @type = :horizontal
    end
  
  end

  def draw(x,y,z = @z)
    @image.draw(x,y,z)
  end
end

class GameWindow < Gosu::Window
  def initialize
    super 600, 480, false, 50
    self.caption = "Gosu Pong Game"
    @player1_score = 0
    @player2_score = 0  
    @song = Gosu::Song.new(self, Ruboto::R::raw::chriss_onac_tempo_red)
    @beep = Gosu::Sample.new(self, Ruboto::R::raw::beep)
    @player1_x = 0
    # 25 is to compesate square size of the ball
    @player1_y = 250 + 25
    @player2_x = 593
    @player2_y = 100 + 25
    @size = 110
    @size2 = @size/2 - 25
    @ball = Ball.new(self, Ruboto::R::drawable::ball, 100, 200, 0, 50, 100, 100)
    @stillObjects = Array.new
    #Left player
    @player1 = StillObject.new(self, Ruboto::R::drawable::bar, [@player1_x, @player1_y], [@player1_x, @player1_y + @size] ,0)
    #Right player
    @player2 = StillObject.new(self, Ruboto::R::drawable::bar, [@player2_x,@player2_y + @size], [@player2_x,@player2_y], 0)    
    #Top plane
    @top_plane = StillObject.new(self, Ruboto::R::drawable::bar, [600,0], [0,0], 0 )    
    #Bottom plane
    @bottom_plane = StillObject.new(self, Ruboto::R::drawable::bar, [0,480], [600,480],  0)

    @stillObjects.push @player1, @player2, @top_plane, @bottom_plane

    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @song.play true
  end

  def update
    
    @stillObjects.each do |obj|
      if @ball.generate_contact obj
        @beep.play 
      end
    end
    
    @ball.update
    
    if @ball.center[0] < 0
      #Player 1 lost
      @player1_score += 1
      #Reset the ball
      @ball.position[0] = 300
      @ball.velocity[0] = -@ball.velocity[0]
      @beep.play
    else
      if @ball.center[0] > 600
        #Player2 lost
        @player2_score += 1
        #Reset the ball
        @ball.position[0] = 300
        @ball.velocity[0] = -@ball.velocity[0]
        @beep.play
      end
    end  
  end
  
  def touch_moved(touch)
    touch.y = touch.y - @size2
    if touch.x < 300
      #Player1
      @player1_y = touch.y
      @player1.bottom_limit[1] = @player1_y + @size
      @player1.top_limit[1] = @player1_y  
    else
      #Player2
      @player2_y = touch.y
      @player2.bottom_limit[1] = @player2_y + @size  
      @player2.top_limit[1] =  @player2_y     
    end
  end
  
  def draw
    @ball.draw
    @player1.draw(@player1_x,@player1_y,0)
    @player2.draw(@player2_x,@player2_y,0)
    @font.draw("Score: A #{@player1_score} B #{@player2_score} ", 10, 10, 3, 1.0, 1.0, 0xffffff00)
  end
 
end

class PongActivity
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
