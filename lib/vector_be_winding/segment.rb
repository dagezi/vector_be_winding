module VectorBeWinding
  class Segment < Shape
    attr_reader :start_point, :direction, :end_point,
                :control_point, :control_point_1

    def initialize(direction, start_point, end_point_hint)
      @direction = direction
      @start_point = start_point
      @end_point =
        if @direction.kind_of?(::Savage::Directions::PointTarget)
          create_vector(@direction.target.x, @direction.target.y, @direction.absolute?)
        elsif @direction.kind_of?(::Savage::Directions::HorizontalTo)
          create_vector(@direction.target, nil, @direction.absolute?)
        elsif @direction.kind_of?(::Savage::Directions::VerticalTo)
          create_vector(nil, @direction.target, @direction.absolute?)
        elsif @direction.kind_of?(::Savage::Directions::ClosePath)
          end_point_hint
        else
          raise "Unknown direction: #{@direction}"
        end
    end

    def create_vector(x, y, absolute)
      if absolute
        Vector.new(x || start_point.x, y || start_point.y)
      else
        start_point + Vector.new(x || 0, y || 0)
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

    def reverse
      Segment.new(reverse_dir, end_point, start_point)
    end

    def reverse_dir
      case @direction.command_code.upcase
      when 'Z'
        ::Savage::Directions::LineTo.new(start_point.x, start_point.y, true)
      when 'L'
        ::Savage::Directions::LineTo.new(start_point.x, start_point.y, true)
      when 'M'
        nil  # Unable to reverse
      when 'H'
        ::Savage::Directions::HorizontalTo.new(start_point.x, true)
      when 'V'
        ::Savage::Directions::VerticalTo.new(start_point.y, true)
      else
        # TODO: Support 'CSQTA'
        raise "Unknown direction: #{@direction}"
      end
    end
  end
end
