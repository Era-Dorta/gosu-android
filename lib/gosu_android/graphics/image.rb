require 'gosu_android/graphics/bitmap'
require 'gosu_android/graphics/color'
require 'gosu_android/graphics/graphicsBase'
require 'gosu_android/math'

module Gosu

  class Image

    def initialize(*args)
      case args.length
      #Argument is ImageData
      when 1
        initialize_1 args[0]
      when 2
        if args[1].class == Bitmap
          initialize_3_bitmap(args[0], args[1])
        else
          initialize_3_file_name(args[0], args[1])
        end
      when 3
        if args[1].class == Bitmap
          initialize_3_bitmap(args[0], args[1], args[2])
        else
          initialize_3_file_name(args[0], args[1], args[2])
        end
      when 6
        if args[1].class == Bitmap
          initialize_7_bitmap(args[0], args[1], args[2], args[3], args[4], args[5])
        else
          initialize_7_file_name(args[0], args[1], args[2], args[3], args[4], args[5])
        end
      when 7
        if args[1].class == Bitmap
          initialize_7_bitmap(args[0], args[1], args[2], args[3], args[4], args[5], args[6])
        else
          initialize_7_file_name(args[0], args[1], args[2], args[3], args[4], args[5], args[6])
        end
      else
        raise ArgumentError
      end
    end

    #Private initialize methods
    private
    def initialize_1 data
      @data = data
    end

    def initialize_3_bitmap(window, source, tileable = false)
      initialize_7_bitmap(window, source, 0, 0, source.width, source.height, tileable)
    end

    def initialize_3_file_name(window, file_name, tileable = false)
      bmp = Gosu::load_image_file(window, file_name)
      initialize_3_bitmap(window, bmp, tileable)
    end

    def initialize_7_file_name(window, file_name, src_x, src_y, src_width, src_height,
              tileable = false)
      bmp = Gosu::load_image_file(window, file_name)
      initialize_7_bitmap(window, bmp, src_x, src_y, src_width, src_height, tileable)
    end

    def initialize_7_bitmap(window, source, src_x, src_y, src_width, src_height,
              tileable = false)
      if tileable
        @data = window.create_image(source, src_x, src_y, src_width, src_height, BF_TILEABLE)
      else
        @data = window.create_image(source, src_x, src_y, src_width, src_height, BF_SMOOTH)
      end
      ObjectSpace.define_finalizer(self, Proc.new{@data.finalize})
    end

    public
    def width
      @data.width
    end

    def height
      @data.height
    end

    def draw(x, y, z, factor_x = 1, factor_y = 1, c = Color::WHITE, mode = :default)
      x2 = x + width*factor_x
      y2 = y + height*factor_y      
      @data.draw(x, y, c, x2, y, c, x, y2, c, x2, y2, c, z, AM_MODES[mode])
    end

    def draw_rot(x, y, z, angle, center_x = 0.5, center_y = 0.5, factor_x = 1.0,
      factor_y = 1.0, c = Color::WHITE, mode = :default)

      size_y = width  * factor_x
      size_y = height * factor_y
      offs_x = Gosu::offset_x(angle, 1)
      offs_y = Gosu::offset_y(angle, 1)

      #Offset to the centers of the original Image's edges when it is rotated
      #by <angle> degrees.
      dist_to_left_x   = +offs_y * size_y * center_x
      dist_to_left_y   = -offs_x * size_y * center_x
      dist_to_right_x  = -offs_y * size_y * (1 - center_x)
      dist_to_right_y  = +offs_x * size_y * (1 - center_x)
      dist_to_top_x    = +offs_x * size_y * center_y
      dist_to_top_y    = +offs_y * size_y * center_y
      dist_to_bottom_x = -offs_x * size_y * (1 - center_y)
      dist_to_bottom_y = -offs_y * size_y * (1 - center_y)

      @data.draw(x + dist_to_left_x  + dist_to_top_x,
        y + dist_to_left_y  + dist_to_top_y, c,
        x + dist_to_right_x + dist_to_top_x,
        y + dist_to_right_y + dist_to_top_y, c,
        x + dist_to_left_x  + dist_to_bottom_x,
        y + dist_to_left_y  + dist_to_bottom_y, c,
        x + dist_to_right_x + dist_to_bottom_x,
        y + dist_to_right_y + dist_to_bottom_y,
        c, z, AM_MODES[mode])
    end

    def self.load_tiles(window, bmp, tile_width, tile_height, tileable)
      images = []

      #If bmp is a file path
      if bmp.class == String or bmp.class == Fixnum
        bmp = Gosu::load_image_file(window, bmp)
      end

      if (tile_width > 0)
        tiles_x = bmp.width / tile_width
      else
        tiles_x = -tile_width
        tile_width = bmp.width / tiles_x
      end

      if (tile_height > 0)
        tiles_y = bmp.height / tile_height
      else
        tiles_y = -tile_height
        tile_height = bmp.height / tiles_y
      end

      tiles_y.times do |y|
        tiles_x.times do |x|
          images.push Image.new(window, bmp, x * tile_width, y * tile_height, tile_width, tile_height, tileable)
        end
      end
      images
    end

  end

end
