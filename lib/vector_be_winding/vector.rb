module VectorBeWinding
  class Vector
    attr_accessor :x, :y

    def initialize(x, y)
      @x = x
      @y = y
    end

    def +(v)
      Vector.new(@x + v.x, @y + v.y)
    end

    def *(s)
      Vector.new(@x * s, @y * s)
    end
  end
end
