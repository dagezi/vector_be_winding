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
      if @bounding_rect == nil
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

    def inspect
      "#<SubPath \"#{svg_subpath.to_command}\">"
    end
  end
end
