require 'gosu'

class GameWindow < Gosu::Window
  def initialize
    #Creates a window of 600 by 400, not fullscreen, at 30 fps
    super 600, 480, false, 30
    #Window title
    self.caption = "Gosu Load Image"
    #Load image from drawable folder
    @image = Gosu::Image.new(self, Ruboto::R::drawable::ship)
  end
  
  def draw
    #Image top left corner will be on top left corner of the screen
    @image.draw(0, 0, 0)
  end
end

#Initialize gosu for android
class LoadImageActivity
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