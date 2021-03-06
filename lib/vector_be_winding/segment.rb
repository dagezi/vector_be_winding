module VectorBeWinding
  class Segment < Shape
    attr_reader :start_point, :direction, :end_point,
                :control, :control_1,
                :radius, :rotation, :large_arc, :sweep

    def initialize(direction, start_point, end_point_hint, prev_segment = nil)
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

      if @direction.instance_of?(::Savage::Directions::QuadraticCurveTo)
        control = @direction.control ||
                  prev_segment.control&.reflect(start_point) ||
                  start_point
        @control = create_vector(control.x, control.y, @direction.absolute?)
      elsif @direction.instance_of?(::Savage::Directions::CubicCurveTo)
        control = @direction.control
        control_1 = @direction.control_1 ||
                  prev_segment.control&.reflect(start_point) ||
                  start_point
        @control = create_vector(control.x, control.y, @direction.absolute?)
        @control_1 = create_vector(control_1.x, control_1.y, @direction.absolute?)
      elsif @direction.instance_of?(::Savage::Directions::ArcTo)
        @radius = @direction.radius
        @rotation = @direction.rotation
        @large_arc = @direction.large_arc
        @sweep = @direction.sweep
      end
    end

    def control_2
      control
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
      if @direction.kind_of?(::Savage::Directions::QuadraticCurveTo)
        # Approximate with triangle
        (start_point - p).cross(control - start_point) +
          (control - p).cross(end_point - control)
      elsif @direction.kind_of?(::Savage::Directions::CubicCurveTo)
        # Approximate with quadrangle
        (start_point - p).cross(control_1 - start_point) +
          (control_1 - p).cross(control_2 - control_1) +
          (control_2 - p).cross(end_point - control_2)
      elsif @direction.kind_of?(::Savage::Directions::ArcTo)
        # Very rough approximation. TODO: Be more precise
        (start_point - p).cross(end_point - start_point) / 2.0 + (sweep ? 1 : -1)
      else
        (start_point - p).cross(end_point - start_point) / 2.0
      end
    end

    def reverse
      Segment.new(reverse_dir, end_point, start_point)
    end

    def reverse_dir
      case @direction.command_code.upcase
      when 'Z', 'L'
        ::Savage::Directions::LineTo.new(start_point.x, start_point.y, true)
      when 'M'
        nil  # Unable to reverse
      when 'H'
        ::Savage::Directions::HorizontalTo.new(start_point.x, true)
      when 'V'
        ::Savage::Directions::VerticalTo.new(start_point.y, true)
      when 'Q', 'T'
        ::Savage::Directions::QuadraticCurveTo.new(
          control.x, control.y, start_point.x, start_point.y, true)
      when 'C', 'S'
        ::Savage::Directions::CubicCurveTo.new(
          control.x, control.y, control_1.x, control_1.y,
          start_point.x, start_point.y, true)
      when 'A'
        ::Savage::Directions::ArcTo.new(
          radius.x, radius.y, rotation, large_arc, !sweep, start_point.x, start_point.y, true)
      else
        raise "Unknown direction: #{@direction}"
      end
    end
  end
end
