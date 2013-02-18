require 'gosu'

class Player
  attr_reader :score

  def initialize(window)
    @image = Gosu::Image.new(window, "/mnt/sdcard/jruby/media/Ship.png", false)
    @beep = Gosu::Sample.new(window, "/mnt/sdcard/jruby/media/Beep.wav")
    @x = @y = 0.0
    @score = 0
  end

end



class GameWindow < Gosu::Window 
  def initialize
    super(640, 480, false)
    self.caption = "Pong Game"
        
    @player = Player.new(self)
    @player.warp(420, 240)

    @player2 = Player.new(self)
    @player2.warp(120, 240)

    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
  end

  def update
  end

  def touch_moved(touch)
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
