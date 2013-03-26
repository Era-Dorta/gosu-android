require 'gosu_android/graphics/imageData'

module Gosu

    class LargeImageData < ImageData
      def initilialize(graphics, source, part_width, part_height, border_flags)
        @full_width = source.width()
        @full_height = source.height()
        @parts_x = (1.0 * source.width() / @part_width).ceil.truncate
        @parts_y = (1.0 * source.height() / @part_height).ceil.truncate
        @part_width = part_width
        @part_height = part_height
        @graphics = graphics

        @parts = Array.new(@parts_x * @parts_y)

        @parts_y.times do |y|
          @parts_x.times do |x|
            #The right-most parts don't necessarily have the full width.
            src_width = @part_width
            if (x == @parts_x - 1 and source.width() % @part_width != 0)
                src_width = source.width() % @part_width
            end
            #Same for the parts on the bottom.
            src_height = @part_height
            if (y == @parts_y - 1 and source.height() % @part_height != 0)
                src_height = source.height() % @part_height
            end
            localBorderFlags = BF_TILEABLE
            if (x == 0)
                localBorderFlags = (localBorderFlags & ~BF_TILEABLE_LEFT) | (borderFlags & BF_TILEABLE_LEFT)
            end
            if (x == @parts_x - 1)
                localBorderFlags = (localBorderFlags & ~BF_TILEABLE_RIGHT) | (borderFlags & BF_TILEABLE_RIGHT)
            end
            if (y == 0)
                localBorderFlags = (localBorderFlags & ~BF_TILEABLE_TOP) | (borderFlags & BF_TILEABLE_TOP)
            end
            if (y == @parts_y - 1)
                localBorderFlags = (localBorderFlags & ~BF_TILEABLE_BOTTOM) | (borderFlags & BF_TILEABLE_BOTTOM)
            end

            @parts[y * @parts_x + x] = @graphics.create_image(source, x * @part_width, y * @part_height, src_width, src_height, localBorderFlags)
          end
        end
      end

      def width
        @full_width
      end

      def height
        @full_height
      end

      def ipl(a,b,ratio)
        a+(b-a)*ratio
      end

      def draw( x1,  y1,  c1, x2,  y2,  c2, x3,  y3,  c3, x4,  y4,  c4, z, mode)

        if Gosu::reorder_coordinates_if_necessary(x1, y1, x2, y2, x3, y3, c3, x4, y4, c4)
          x3, y3, c3, x4, y4, c4 = x4, y4,c4, x3, y3, c3
        end

        c = Color::NONE

        @parts_y.times do |py|
          @parts_x.times do |px|
            part = @parts[py * @parts_x + px];

            rel_xl = (px.to_f * @part_width) / width
            rel_xr = (px.to_f * @part_width + part.width) / width
            rel_yt = (py.to_f * @part_height) / height
            rel_yb = (py.to_f * @part_height + part.height) / height

            abs_xtl = ipl(ipl(x1, x3, rel_yt), ipl(x2, x4, rel_yt), rel_xl)
            abs_xtr = ipl(ipl(x1, x3, rel_yt), ipl(x2, x4, rel_yt), rel_xr)
            abs_xbl = ipl(ipl(x1, x3, rel_yb), ipl(x2, x4, rel_yb), rel_xl)
            abs_xbr = ipl(ipl(x1, x3, rel_yb), ipl(x2, x4, rel_yb), rel_xr)

            abs_ytl = ipl(ipl(y1, y3, rel_yt), ipl(y2, y4, rel_yt), rel_xl)
            abs_ytr = ipl(ipl(y1, y3, rel_yt), ipl(y2, y4, rel_yt), rel_xr)
            abs_ybl = ipl(ipl(y1, y3, rel_yb), ipl(y2, y4, rel_yb), rel_xl)
            abs_ybr = ipl(ipl(y1, y3, rel_yb), ipl(y2, y4, rel_yb), rel_xr)

            part.draw(abs_xtl, abs_ytl, c, abs_xtr, abs_ytr, c,
                abs_xbl, abs_ybl, c, abs_xbr, abs_ybr, c, z, mode)
          end
        end

      end

      def gl_tex_info
        0
      end

      def to_bitmap()
        bitmap = Bitmap.new(width, height)
        @parts_y.times do |y|
          @parts_x.times do |x|
            bitmap.insert(@parts[y * @parts_x + x].to_bitmap, x * @part_width, y * @part_height)
          end
        end
        bitmap
      end

      def insert(bitmap, at_x, at_y)
        @parts_y.times do |y|
          @parts_x.times do |x|
            @parts[y * @parts_x + x].insert(bitmap, at_x - x* @part_width, at_y -y * part_height)
          end
        end
      end
    end
end
