require 'gosu'

class GameWindow < Gosu::Window
  def initialize
    #Creates a window of 600 by 400, not fullscreen, at 30 fps
    super 600, 480, false, 30
    self.caption = "Gosu Use Keyboard"
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
    #Bring up the keyboard
    self.show_soft_keyboard
  end

  def button_down(id)
    #Save the key value
    @key = id
  end
  
  def draw
    #Show which key the user pressed
    @font.draw("Press a key to see its code: #{@key}", 10, 10, 3, 1.0, 1.0, 0xffffff00)
  end
end

#Initialize gosu for android
class UseKeyboardActivity
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