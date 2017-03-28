module VectorBeWinding
  class Vector
    attr_accessor :x, :y

    def initialize(x, y)
      @x = x
      @y = y
    end

    def ==(v)
      x == v.x && y == v.y
    end

    def -@()
      Vector.new(-x, -y)
    end

    def +(v)
      Vector.new(x + v.x, y + v.y)
    end

    def -(v)
      Vector.new(x - v.x, y - v.y)
    end

    def *(s)
      Vector.new(x * s, y * s)
    end

    def dot(v)
      x * v.x + y * v.y
    end

    def norm
      dot(self)
    end

    def cross(v)
      x * v.y - y * v.x
    end

    # Create reflection point of self 
    def reflect(v)
      v + (v - self)
    end
  end
end
