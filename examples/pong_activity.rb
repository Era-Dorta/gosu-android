require 'gosu'

class Player
  attr_reader :score

  def initialize(window, x, y)
    @image = Gosu::Image.new(window, Ruboto::R::drawable::player, false)
    @beep = Gosu::Sample.new(window, Ruboto::R::raw::beep)
    @x = x
    @y = y
    @score = 0
  end
  
  def warp(x, y)
    @y = y
  end

  def draw
    @image.draw(@x, @y, ZOrder::Player)
  end

end



class GameWindow < Gosu::Window 
  def initialize
    super(640, 480, false)
    self.caption = "Pong Game"
        
    @player = Player.new(self, 0, 50)

    @player2 = Player.new(self, 300, 50)
    
    @squ = Gosu::Square.new(self, Ruboto::R::drawable::ball, 100, 200, 0, 50, 20, 100, 100)
    
    @p1 = Gosu::Plane.new(self, 1, 0, 0)
    @p2 = Gosu::Plane.new(self, 0, 1, 0)
    @p3 = Gosu::Plane.new(self, -1, 0, 600)
    @p4 = Gosu::Plane.new(self, 0, -1, 480)    

  end

  def update
  end

  def object_collied( coordinates )
    
  end

  def touch_moved(touch)
    if(touch.x < 100)
      @player.warp(touch.x, touch.y)
    else
      @player2.warp(touch.x, touch.y)
    end
  end

  def draw
    @player.draw
    @player2.draw
  end

  def button_down(id)
    if id == Gosu::KbEscape then
      close
    end
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
