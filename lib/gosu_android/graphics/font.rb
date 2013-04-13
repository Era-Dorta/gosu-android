require 'gosu_android/requires'
require 'gosu_android/graphics/color'
require 'gosu_android/graphics/graphicsBase'
require 'gosu_android/graphics/image'

module Gosu

  class FontsManager

    def initialize(window)
       file = Ruboto::R::drawable::character_atlas8
       font_vector = Gosu::Image::load_tiles(window, file, 13, 25, false)
       symbols = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+-/*\'\"!?[]{}_.,:; "
       @font_symbols = {}
       i = 0
       symbols.each_char do |symbol|
         @font_symbols[symbol] = font_vector[i]
         i += 1
       end
    end

    def getSymbol(symbol)
      @font_symbols[symbol]
    end

  end

  class Font
    attr_reader :name, :flags
    def initialize(window, font_name, font_height, font_flags = :ff_bold)
      @window = window
      @fonts_manager = window.fonts_manager
      @name = font_name
      @height = font_height * 2
      @flags = flags
    end

    def height
      @height / 2
    end

    #Draws text so the top left corner of the text is at (x; y).
    #param text Formatted text without line-breaks.
    def draw(text, x, y, z, factor_x = 1, factor_y = 1, c = Color::WHITE,
      mode = :default)

      offset = 0
      text.each_char do |char|
        (@fonts_manager.getSymbol char ).draw(x + offset, y, z, factor_x, factor_y, c, mode)
        offset += 10
      end

    end

  end

  def self.default_font_name
    JavaImports::Typeface::MONOSPACE
  end

end
