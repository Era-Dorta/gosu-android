require 'gosu'

class GameWindow < Gosu::Window
  def initialize
    super 600, 480, false, 30
    self.caption = "Gosu Load Image"
    @image = Gosu::Image.new(self, Ruboto::R::drawable::ship)
  end
  
  def draw
    @image.draw(0, 0, 0)
  end
end

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