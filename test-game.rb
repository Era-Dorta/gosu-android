require 'gosu'

class GameWindow < Gosu::Window
  def initialize
    super 640, 480, false
    self.caption = "Gosu Tutorial Game"
    @background_image = Gosu::Image.new(self, "/mnt/sdcard/jruby/media/Starfighter.bmp", true)
    @offset = 0
    @beep = Gosu::Sample.new(self, "/mnt/sdcard/jruby/media/Beep.wav")
    @song = Gosu::Song.new(self, "/mnt/sdcard/jruby/media/Engel.mp3")
    @x = 0
    @y = 0
  end
  
  def update
  end
  
  def draw
    @background_image.draw(@x, @y, 0)
    draw_line(100, 100, Gosu::Color::RED, 0, 0, Gosu::Color::RED)
    draw_line(100, 200 + @offset, Gosu::Color::GREEN, 0, 50 + @offset, Gosu::Color::GREEN)
    draw_triangle(20,100, Gosu::Color::RED, 0, 50, Gosu::Color::RED,  110, 50, Gosu::Color::RED)
    draw_quad(100 + @offset,100, Gosu::Color::BLUE, 100 +  @offset, 200, Gosu::Color::GREEN,  200 + @offset, 100, Gosu::Color::BLUE,  200 + @offset, 200, Gosu::Color::BLUE)
  end
  
  def touch_moved touch
    @x = touch.x
    @y = touch.y
    @beep.play
    if not @song.playing?
      @song.start
    end  
  end  
end

$activity.start_ruboto_activity "$gosu" do
  def on_create(bundle)
    puts "On create activity"
    Gosu::AndroidInitializer.instance.start
    rescue Exception => e
      puts "#{ e } (#{ e.class } #{e.message} #{e.backtrace.inspect} )!"    
  end  
  
  def on_ready
    puts "On ready activity"
    window = GameWindow.new
    window.show    
    rescue Exception => e
    puts "#{ e } (#{ e.class } #{e.message} #{e.backtrace.inspect} )!"    
  end
end
