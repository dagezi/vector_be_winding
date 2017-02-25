module VectorBeWinding
  class SubPath < Shape
    include SpatialTree

    attr_reader :start_point, :svg_subpath, :segments

    def self.with_string(path_string)
      path = Savage::Parser.parse(path_string)
      raise "No subpaths: ${path_string}" if path.subpaths.empty?
      SubPath.new(path.subpaths.last)
    end

    def initialize(svg_subpath, start_point = Vector.new(0,0))
      @svg_subpath = svg_subpath
      @segments = []

      point = start_point
      @svg_subpath.directions.each { |dir|
        segment = Segment.new(dir, point, start_point)
        point = segment.end_point
        if segment.direction.kind_of?(Savage::Directions::MoveTo)
          start_point = point
        else
          @segments << segment
        end
      }
      @start_point = start_point
    end

    def bounding_rect
      unless @bounding_rect
        rect = Rect.with_vectors(start_point, start_point)
        segments.each { |segment|
          rect |= segment.bounding_rect
        }
        @bounding_rect = rect
      end
      @bounding_rect
    end

    # Calculate direction area of this path.
    # It's positive iff the path forms clockwise.

    def area()
      segments.map { |seg| seg.area(start_point) }.reduce(:+)
    end

    def reverse
      svg_subpath = Savage::SubPath.new(start_point.x, start_point.y)
      svg_subpath.directions.concat(segments.map(&:reverse_dir).reverse)
      svg_subpath.close_path

      SubPath.new(svg_subpath)
    end

    def be_winding(sign = 1)
      wound = if area * sign >= 0
                SubPath.new(svg_subpath)
              else
                reverse
              end
      wound.children.concat(children.map { |c| c.be_winding(-sign) })
      wound
    end

    def inspect
      "#<SubPath \"#{svg_subpath.to_command}\">"
    end

    def to_command
      @svg_subpath.to_command
    end
  end
end
