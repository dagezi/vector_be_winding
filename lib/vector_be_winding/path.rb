module VectorBeWinding
  class Path < Shape
    include SpatialTree

    attr_reader :sub_paths

    def self.with_string(path_string)
      begin
        svg_path = Savage::Parser.parse(path_string)
      rescue => e
        raise ArgumentError, "Possibly wrong path string \"#{path_string}\""
      end
      Path.new(svg_path.subpaths.map { |svg_subpath| SubPath.with_svg(svg_subpath) })
    end

    def initialize(sub_paths, is_tree = false)
      if is_tree
        @children = sub_paths
        @sub_paths = []
        children.each {|root| root.each { |subpath| @sub_paths << subpath }}
      else
        @sub_paths = sub_paths
        sub_paths.each {|p| insert_to_tree(p)}
      end
    end

    def bounding_rect
      @bounding_rect ||= @sub_paths.map(&:bounding_rect).reduce(:|)
    end

    def area
      sub_paths.map(&:area).reduce(:+)
    end

    def inspect
      "#<Path>"
    end

    def is_winding(sign = 1)
      children.all? { |c| c.is_winding }
    end

    def be_winding()
      wounds = children.map(&:be_winding)
      Path.new(wounds, true)
    end

    def to_command
      sub_paths.map(&:to_command).join
    end
  end
end
