module VectorBeWinding
  class Path < Shape
    include SpatialTree

    attr_reader :sub_paths, :svg_path

    def self.with_string(path_string)
      path = Savage::Parser.parse(path_string)
      Path.new(path)
    end

    def initialize(svg_path)
      @svg_path = svg_path
      @sub_paths = svg_path.subpaths.map { |svg_subpath| SubPath.new(svg_subpath) }

      sub_paths.each {|p| insert_to_tree(p)}
    end

    def bounding_rect
      @bounding_rect ||= @sub_paths.map(&:bounding_rect).reduce(:|)
    end

    def inspect
      "#<Path \"#{svg_path.to_command}\">"
    end

    def be_winding
      # TODO: implement
      # Create tree
      # Output it with right direction
    end
  end
end
