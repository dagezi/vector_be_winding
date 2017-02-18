module VectorBeWinding
  class Segment < Shape
    attr_reader :start_point, :direction, :end_point

    def initialize(direction, start_point, end_point_hint)
      @direction = direction
      @start_point = start_point
      @end_point =
        if @direction.kind_of?(::Savage::Directions::PointTarget)
          if @direction.absolute?
            Vector.new(@direction.target.x, @direction.target.y)
          else
          start_point +
              Vector.new(@direction.target.x, @direction.target.y)
          end
        elsif @direction.kind_of?(::Savage::Directions::HorizontalTo)
          if @direction.absolute?
            Vector.new(@direction.target, start_point.y)
          else
            start_point + Vector.new(@direction.target, 0)
          end
        elsif @direction.kind_of?(::Savage::Directions::VerticalTo)
          if @direction.absolute?
            Vector.new(start_point.x, @direction.target)
          else
            start_point + Vector.new(0, @direction.target)
          end
        elsif @direction.kind_of?(::Savage::Directions::ClosePath)
          end_point_hint
        else
          raise "Unknown direction: #{@direction}"
        end
    end

    def bounding_rect
      @bounding_rect ||=
        Rect.new(start_point.x, start_point.y, end_point.x, end_point.y)
    end

    # Calculate direction area of the triangle (p, start_point, end_point)
    # It must be positive iff the three points forms clockwise order.
    def area(p)
      (start_point - p).cross(end_point - start_point) / 2.0
    end
  end
end
