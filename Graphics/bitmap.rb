require 'requires'
require 'color'

module Gosu
  #Custom java files
  java_import 'gosu.java.Bitmap'
  
  #TODO define load_image with reader argument
  def self.load_image_file(window, file_name)
    Gosu::Bitmap.new(window.activity.getApplicationContext, file_name)
  end
end