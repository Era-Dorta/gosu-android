require 'gosu_android/graphics/graphicsBase'

module Gosu
  def self.apply_border_flags(dest, source, src_x, src_y, src_width, src_height, border_flags)
    dest.resize(src_width + 2, src_height + 2)

    #The borders are made "harder" by duplicating the original bitmap's
    #borders.

    #Top.
    if (border_flags & BF_TILEABLE_TOP)
        dest.insert(source, 1, 0, src_x, src_y, src_width, 1)
    end
    #Bottom.
    if (border_flags & BF_TILEABLE_BOTTOM)
        dest.insert(source, 1, dest.height - 1,
            src_x, src_y + src_height - 1, src_width, 1)
    end
    #Left.
    if (border_flags & BF_TILEABLE_LEFT)
        dest.insert(source, 0, 1, src_x, src_y, 1, src_height)
    end
    #Right.
    if (border_flags & BF_TILEABLE_RIGHT)
        dest.insert(source, dest.width - 1, 1,
            src_x + src_width - 1, src_y, 1, src_height)
    end
    #Top left.
    if ((border_flags & BF_TILEABLE_TOP) and (border_flags & BF_TILEABLE_LEFT))
        dest.set_pixel(0, 0,
            source.get_pixel(src_x, src_y))
    end
    #Top right.
    if ((border_flags & BF_TILEABLE_TOP) and (border_flags & BF_TILEABLE_RIGHT))
        dest.set_pixel(dest.width - 1, 0,
            source.get_pixel(src_x + src_width - 1, src_y))
    end
    #Bottom left.
    if ((border_flags & BF_TILEABLE_BOTTOM) and (border_flags & BF_TILEABLE_LEFT))
        dest.set_pixel(0, dest.height - 1,
            source.get_pixel(src_x, src_y + src_height - 1))
    end
    #Bottom right.
    if ((border_flags & BF_TILEABLE_BOTTOM) and (border_flags & BF_TILEABLE_RIGHT))
        dest.set_pixel(dest.width - 1, dest.height - 1,
            source.get_pixel(src_x + src_width - 1, src_y + src_height - 1))
    end
    #Now put the final image into the prepared borders.
    dest.insert(source, 1, 1, src_x, src_y, src_width, src_height)
  end
end
