require 'gosu'

module ZOrder
  Background, Stars, Player, UI = *0..3
end

class Player
  attr_reader :score

  def initialize(window)
    @image = Gosu::Image.new(window, Ruboto::R::drawable::ship, false)
    @beep = Gosu::Sample.new(window, Ruboto::R::raw::beep)
    @x = @y = @vel_x = @vel_y = @angle = 0.0
    @score = 0
  end

  def warp(x, y)
    @x, @y = x, y
  end

  def draw
    @image.draw_rot(@x, @y, ZOrder::Player, @angle)
  end
  
  def collect_stars(stars)
    stars.reject! do |star|
      if Gosu::distance(@x, @y, star.x, star.y) < 35 then
        @score += 10
        @beep.play
        true
      else
        false
      end
    end
  end
end

class Star
  attr_reader :x, :y
  
  def initialize(animation)
    @animation = animation
    @color = Gosu::Color.new(0xff000000)
    @color.red = rand(256 - 40) + 40
    @color.green = rand(256 - 40) + 40
    @color.blue = rand(256 - 40) + 40
    @x = rand * 640
    @y = rand * 480
  end

  def draw  
    img = @animation[Gosu::milliseconds / 100 % @animation.size]
    img.draw(@x - img.width / 2.0, @y - img.height / 2.0,
        ZOrder::Stars, 1, 1, @color, Gosu::AM_ADD)
  end
end

class GameWindow < Gosu::Window
  def initialize
    super(640, 480, false)
    self.caption = "Gosu Tutorial Game"
    
    @background_image = Gosu::Image.new(self, Ruboto::R::drawable::space, true)
    
    @player = Player.new(self)
    @player.warp(320, 240)

    @star_anim = Gosu::Image::load_tiles(self, Ruboto::R::drawable::star, 25, 25, false)
    @stars = Array.new
    
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
  end

  def update
    @player.collect_stars(@stars)
    #Normally 25 stars
    if rand(100) < 4 and @stars.size < 5 then
      @stars.push(Star.new(@star_anim))
    end
  end

  def touch_moved(touch)
    @player.warp(touch.x, touch.y)
  end

  def draw
    @background_image.draw(0, 0, ZOrder::Background)
    @player.draw
    @stars.each { |star| star.draw }
    @font.draw("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0, 0xffffff00)
  end

  def button_down(id)
    if id == Gosu::KbEscape then
      close
    end
  end
end

class TestGameTouchActivity
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