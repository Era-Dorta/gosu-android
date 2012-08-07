require 'gosu'

class GameWindow < Gosu::Window
  def initialize
    super 640, 480, false
    self.caption = "Gosu Tutorial Game"
  end
  
  def update
  end
  
  def draw
  end
end

$activity.start_ruboto_activity "$gosu" do 
  def on_create(bundle)
    window = GameWindow.new
    window.show 
    window.close   
  end
end

