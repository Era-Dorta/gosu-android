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
    @dt = window.update_interval
  end
  
  def update
    @position[0] += @velocity[0]*@dt
    @position[1] += @velocity[1]*@dt
    @center = [@position[0] + @size, @position[1] + @size]    
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
    super 600, 480, false, 30
    self.caption = "Gosu Arkanoid"
    @score = 0  
    @song = Gosu::Song.new(self, Ruboto::R::raw::chriss_onac_tempo_red)
    @beep = Gosu::Sample.new(self, Ruboto::R::raw::beep)
    @p1x = 0
    @stillObjects = Array.new
  
    @ball = Ball.new(self, Ruboto::R::drawable::yellow_square, 100, 200, 0, 10, 100, 100)

    @player_x = 300
    @player_y = 473    
    @size = 110
    # 5 is to compesate square size of the ball
    @size2 = @size/2 - 5    
    @player = StillObject.new(self,Ruboto::R::drawable::bar_hor, [@player_x, @player_y], [@player_x + @size, @player_y],  0)

    #Left plane
    @p1 = StillObject.new(self, Ruboto::R::drawable::bar, [0, 0], [0, 480], 0)
    #Top plane
    @p2 = StillObject.new(self, Ruboto::R::drawable::bar, [600, 0], [0, 0], 0)
    #Right plane
    @p3 = StillObject.new(self,Ruboto::R::drawable::bar, [600, 480], [600, 0], 0)
    
    @blocks = []
    @blocks_position = []
    block_x = 150
    block_y = 120
    img = Ruboto::R::drawable::bar_hor
    2.times do |i|
      3.times do |j|
        @blocks.push StillObject.new(self, img, [block_x + (@size + 30)*i, block_y + 30*j ], [block_x + @size*(i + 1) + 30*i, block_y + 30*j ],  0)
        @blocks_position.push [block_x + (@size + 30)*i, block_y + 30*j]
        @stillObjects.push @blocks.last
      end
    end
    
    @stillObjects.push @p1, @p2, @p3, @player
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @song.play true
  end

  def update
    
    #Collision detection
    to_delete = nil
    @stillObjects.each do |obj|
      if @ball.generate_contact obj
        if(@blocks.include? obj )      
          @score += 1
          to_delete = obj
        end
        @beep.play       
      end
    end
    
    if to_delete != nil
      @blocks_position.delete_at(@blocks.index to_delete)
      @blocks.delete to_delete
      @stillObjects.delete to_delete    
    end
    
    @ball.update
      
    if @ball.center[1] > 480
      @ball.position[1] = 200
      @ball.velocity[1] = -@ball.velocity[0]
      @beep.play      
    end
    
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

class ArkanoidActivity
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
