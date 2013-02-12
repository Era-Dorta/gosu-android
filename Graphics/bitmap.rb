require 'requires'
require 'color'

module Gosu
  #Custom java files
  java_import 'gosu.java.Bitmap'
  
  #TODO define load_image with reader argument
  def self.load_image_file(file_name)
    Gosu::Bitmap.new(file_name)
  end
end