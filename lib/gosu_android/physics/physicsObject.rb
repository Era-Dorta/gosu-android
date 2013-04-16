require 'gosu_android/graphics/image'

module Gosu

  def self.dot_product(l1, l2)
    sum = 0
    for i in 0...l1.size
        sum += l1[i] * l2[i]
    end
    sum
  end

  def self.cross_product(l1,l2)
    res = []
    res.push( l1[1]*l2[2] - l1[2]*l2[1] );
    res.push( l1[2]*l2[0] - l1[0]*l2[2] );
    res.push( l1[0]*l2[1] - l1[1]*l2[0] );
    d = res.max
    if(d == 0)
      d = res.min
      res[0] = res[0]/-d
      res[1] = res[1]/-d
    else
      res[0] = res[0]/d
      res[1] = res[1]/d
    end
    res
  end

  class Square
    attr_accessor :velocity
    attr_reader :position, :center
    attr_reader :mass_inverted, :restitution
    def initialize(window, file_name, x, y, z, size, mass_inverted,
      velocity_x = 0, velocity_y = 0, restitution = 1, tileable = false)
      @window = window
      @position = [x,y]
      @size = size / 2
      @center = [@position[0] + @size, @position[1] + @size]
      @z = z
      @restitution = restitution
      @velocity = [velocity_x, velocity_y]
      @mass_inverted = mass_inverted
      @image = Gosu::Image.new(@window, file_name , tileable)
      @dt = @window.internal_update_interval
    end

    def integrate
      @position[0] += @velocity[0]*@dt
      @position[1] += @velocity[1]*@dt
      @center = [@position[0] + @size, @position[1] + @size]
    end

    def generate_contact other_object
      if other_object.class == Square
      elsif other_object.class == Plane
        if @center[0] - @size < other_object.top_limit[0] and other_object.bottom_limit[0] < @center[0] + @size and
          @center[1] - @size < other_object.bottom_limit[1] and other_object.top_limit[1] < @center[1] + @size
          #Calculate new velocity, after the hit
          if other_object.type == :vertical
            @velocity[0] -= (1 + @restitution) * @velocity[0]
          else
            @velocity[1] -= (1 + @restitution) * @velocity[1]
          end
          #Call window event
          @window.object_collided( @position[0], @position[1], other_object )
        end
      end
    end

    def draw
      @image.draw(@position[0], @position[1], @z)
    end

  end

  # Bottom ----- Top
  #
  #  Top
  #   |
  #   |
  #   |
  # Bottom
  class Plane
    attr_accessor :bottom_limit, :top_limit
    attr_reader :type
    def initialize(window, file_name, p0, p1, z)
      @window = window
      @image = Gosu::Image.new(@window, file_name)
      @z = z
      @top_limit = Array.new p0
      @bottom_limit = Array.new p1

      if(@bottom_limit[0] > @top_limit[0] or @bottom_limit[1] < @top_limit[1])
        @top_limit, @bottom_limit = @bottom_limit, @top_limit
      end

      if @bottom_limit[0] == @top_limit[0]
        @type = :vertical
      elsif @bottom_limit[1] == @top_limit[1]
        @type = :horizontal
      else
        raise "Planes can only be horizontal or vertical"
      end

    end

    def draw(x,y,z = @z)
      @image.draw(x,y,z)
    end

  end
end
