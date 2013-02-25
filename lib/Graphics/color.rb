#require 'math.rb'

module Gosu
  
  class HSV < Struct.new(:h, :s, :v)
  end

  #Custom java files
  java_import 'gosu.java.Color'
    
  Gosu::Color::NONE = Color.new(0x00000000)
  Gosu::Color::BLACK = Color.new(0xff000000)
  Gosu::Color::GRAY = Color.new(0xff808080)
  Gosu::Color::WHITE = Color.new(0xffffffff)
  Gosu::Color::AQUA = Color.new(0xff00ffff)
  Gosu::Color::RED = Color.new(0xffff0000)
  Gosu::Color::GREEN = Color.new(0xff00ff00)
  Gosu::Color::BLUE = Color.new(0xff0000ff)
  Gosu::Color::YELLOW = Color.new(0xffffff00)
  Gosu::Color::FUCHSIA = Color.new(0xffff00ff)
  Gosu::Color::CYAN = Color.new(0xff00ffff)    

  class Color
    GL_FORMAT = 0x1908
  end   

end