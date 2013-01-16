module Gosu
  #Contains information about the underlying OpenGL texture and the
  #u/v space used for image data. Can be retrieved from some images
  #to use them in OpenGL operations.  
  class GLTexInfo < Struct.new(:tex_name, :left, :right, :top, :bottom); end 
    
  #The ImageData class is an abstract base class for drawable images.
  #Instances of classes derived by ImageData are usually returned by
  #Graphics::createImage and usually only used to implement drawing
  #primitives like Image, which then provide a more specialized and
  #intuitive drawing interface.  
  class ImageData
    def width; end
    def height; end
    
    def draw( x1,  y1,  c1, x2,  y2,  c2, x3,  y3,  c3, x4,  y4,  c4, z, mode);
    end  
        
    def gl_tex_info; end
    def to_bitmap; end      
  end
  
end