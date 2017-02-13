module VectorBeWinding
  class Rect < Shape
    attr_reader :x0, :y0, :x1, :y1

    def initialize(x0, y0, x1, y1)
      @x0 = x0
      @y0 = y0
      @x1 = x1
      @y1 = y1
    end

    def self.newWithVectors(v0, v1)
      self.new(v0.x, v0,y, v1.x, v1.y)
    end

    def bounding_rect
      self
    end

    def intersectedness(shape1)
      if shape1.class == Rect
        [range_intersectedness(x0, x1, shape1.x0, shape1.x1),
          range_intersectedness(y0, y1, shape1.y0, shape1.y1)].min
      else
        shape1.intersectedness(self)
      end
    end

    def self.range_intersectedness(a0, a1, b0, b1)
      if a0 > a1
        a0, a1 = a1, a0
      end
      if b0 > b1
        b0, b1 = b1, b0
      end

      if a0 < b0
        a1 - b0
      else
        b1 - a0
      end
    end

    # Very naive definition. Each subclass is expected to override it
    def containingness(shape1)
      if shape1.class == Rect
        [range_containingness(x0, x1, shape1.x0, shape1.x1),
          range_containingness(y0, y1, shape1.y0, shape1.y1)].min
      else
        shape1.containingness(self)
      end
    end

    def self.range_containingness(a0, a1, b0, b1)
      if a0 > a1
        a0, a1 = a1, a0
      end
      if b0 > b1
        b0, b1 = b1, b0
      end

      if a0 <= b0
        (b0 - a0) * (a1 - b1)
      else
        -1
      end
    end
  end
end
