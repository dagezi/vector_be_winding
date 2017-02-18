require "spec_helper"

module VectorBeWinding
  describe SubPath do
    let (:line_path) { SubPath.with_string('L5,20Z') }
    let (:clockwise_triangle_path) {SubPath.with_string('M10,10L20,20h-10Z')}
    let (:anticlockwise_triangle_path) {SubPath.with_string('M10,10L20,20v-10Z')}

    it "can parse line path" do
      expect(line_path.start_point).to eq(Vector.new(0, 0))
      expect(line_path.bounding_rect).to eq(Rect.new(0, 0, 5, 20))
    end

    it "can parse triangle path" do
      expect(clockwise_triangle_path.start_point).to eq(Vector.new(10, 10))
      expect(clockwise_triangle_path.segments.count).to eq(3)
      expect(clockwise_triangle_path.segments[0].end_point).to eq(Vector.new(20, 20))
      expect(clockwise_triangle_path.segments[2].end_point).to eq(Vector.new(10, 10))
      expect(clockwise_triangle_path.bounding_rect).to eq(Rect.new(10, 10, 20, 20))
    end

    it "can calculate directed area" do
      expect(clockwise_triangle_path.area).to eq(50)
      expect(anticlockwise_triangle_path.area).to eq(-50)
    end
  end
end
