module VectorBeWinding
  class Rect < Shape
    attr_reader :left, :top, :right, :bottom

    def initialize(left, top, right, bottom)
      @left, @right = if left <= right then [left, right] else [right, left] end
      @top, @bottom = if top <= bottom then [top, bottom] else [bottom, top] end
    end

    def self.with_vectors(v0, v1)
      self.new(v0.x, v0.y, v1.x, v1.y)
    end

    def bounding_rect
      self
    end

    def ==(rect1)
      left == rect1.left && top == rect1.top &&
        right == rect1.right && bottom == rect1.bottom
    end

    def empty?
      left == right || top == bottom
    end

    def |(rect1)
      Rect.new([left, rect1.left].min, [top, rect1.top].min,
               [right, rect1.right].max, [bottom, rect1.bottom].max)
    end

    def &(rect1)
      newLeft = [left, rect1.left].max
      newTop = [top, rect1.top].max
      newRight = [right, rect1.right].min
      newBottom = [bottom, rect1.bottom].min

      if (newLeft <= newRight && newTop <= newBottom) 
        Rect.new(newLeft, newTop, newRight, newBottom)
      else
        nil
      end
    end

    def intersectedness(shape1)
      if shape1.class == Rect
        [range_intersectedness(left, right, shape1.left, shape1.right),
          range_intersectedness(top, bottom, shape1.top, shape1.bottom)].min
      else
        shape1.intersectedness(self)
      end
    end

    def self.range_intersectedness(a0, a1, b0, b1)
      if a0 < b0
        a1 - b0
      else
        b1 - a0
      end
    end

    # Very naive definition. Each subclass is expected to override it
    def containingness(shape1)
      if shape1.class == Rect
        [range_containingness(left, right, shape1.left, shape1.right),
          range_containingness(top, bottom, shape1.top, shape1.bottom)].min
      else
        shape1.containingness(self)
      end
    end

    # check [a0, a0] contains [b0, b1]
    def self.range_containingness(a0, a1, b0, b1)
      if a0 <= b0 && b1 <= a1
        (b0 - a0) * (a1 - b1)
      else
        -1
      end
    end
  end
end
