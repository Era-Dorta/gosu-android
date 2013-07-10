require 'gosu'

module Resources
  if defined? Ruboto
    Resources::STAR_FIGHTER = Ruboto::R::drawable::star_fighter
    Resources::BEEP = Ruboto::R::raw::beep
    Resources::SPACE = Ruboto::R::drawable::space
    Resources::STAR = Ruboto::R::drawable::star
  else
    Resources::STAR_FIGHTER = "media/Starfighter.bmp"
    Resources::BEEP = "media/Beep.wav"
    Resources::SPACE = "media/Space.png"
    Resources::STAR = "media/Star.png"    
  end
end

module ZOrder
  Background, Stars, Player, UI = *0..3
end

class Player
  attr_reader :score

  def initialize(window)
    @image = Gosu::Image.new(window, Resources::STAR_FIGHTER, false)
    @beep = Gosu::Sample.new(window, Resources::BEEP)
    @x = @y = @vel_x = @vel_y = @angle = 0.0
    @score = 0
  end

  def warp(x, y)
    @x, @y = x, y
  end
  
  def turn_left
    @angle -= 4.5
  end
  
  def turn_right
    @angle += 4.5
  end
  
  def accelerate
    @vel_x += Gosu::offset_x(@angle, 0.5)
    @vel_y += Gosu::offset_y(@angle, 0.5)
  end
  
  def move
    @x += @vel_x
    @y += @vel_y
    @x %= 640
    @y %= 480
    
    @vel_x *= 0.95
    @vel_y *= 0.95
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
        ZOrder::Stars, 1, 1, @color, :add)
  end
end

class GameWindow < Gosu::Window
  def initialize
    super(640, 480, false)
    self.caption = "Gosu Tutorial Game"
    
    @background_image = Gosu::Image.new(self, Resources::SPACE, true)
    
    @player = Player.new(self)
    @player.warp(320, 240)

    @star_anim = Gosu::Image::load_tiles(self, Resources::STAR, 25, 25, false)
    @stars = Array.new
    
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
  end

  def update
    if button_down? Gosu::KbA then
      @player.turn_left
    end
    if button_down? Gosu::KbD then
      @player.turn_right
    end
    if button_down? Gosu::KbW then
      @player.accelerate
    end
    @player.move
    @player.collect_stars(@stars)
    
    if rand(100) < 4 and @stars.size < 25 then
      @stars << Star.new(@star_anim)
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
      rescue Exception => e
        puts "#{ e } (#{ e.class } #{e.message} #{e.backtrace.inspect} )!"    
    end
  end  
end
