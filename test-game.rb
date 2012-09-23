require 'gosu'

class GameWindow < Gosu::Window
  def initialize
    super 640, 480, false
    self.caption = "Gosu Tutorial Game"
    @offset = 0
  end
  
  def update
  end
  
  def draw
    draw_line(100, 100, Gosu::Color::RED, 0, 0, Gosu::Color::RED)
    draw_line(100, 200 + @offset, Gosu::Color::GREEN, 0, 50 + @offset, Gosu::Color::GREEN)
    draw_triangle(20,100, Gosu::Color::RED, 0, 50, Gosu::Color::RED,  110, 50, Gosu::Color::RED)
    draw_quad(100 + @offset,100, Gosu::Color::BLUE, 100 +  @offset, 200, Gosu::Color::GREEN,  200 + @offset, 100, Gosu::Color::BLUE,  200 + @offset, 200, Gosu::Color::BLUE)
  end
  
  def touch_moved touch
    @offset += 2
  end  
end

$activity.start_ruboto_activity "$gosu" do
  def on_create(bundle)
    window = GameWindow.new
    window.show
  end  
end
