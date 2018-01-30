require "spec_helper"

module VectorBeWinding
  describe SubPath do
    let (:line_path) { SubPath.with_string('L5,20Z') }
    let (:clockwise_triangle_path) {SubPath.with_string('M10,10L20,20h-10Z')}
    let (:anticlockwise_triangle_path) {SubPath.with_string('M10,10L20,20v-10Z')}
    let (:clockwise_not_close) {SubPath.with_string('M10,10L20,20h-10v-10')}
    let (:clockwise_arc_path) {SubPath.with_string('M300,200 a150,150 0 1,1 150,150 z')}
    let (:anticlockwise_arc_path) {SubPath.with_string('M300,200 a150,150 0 1,0 150,-150 z')}

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
      expect(clockwise_not_close.area).to eq(50)

      expect(clockwise_arc_path.area).to be > 0
      expect(anticlockwise_arc_path.area).to be < 0
    end

    describe "reverse" do
      it "reverse simple path" do
        reversed = line_path.reverse

        expect(reversed.start_point).to eq(line_path.start_point)
        expect(reversed.bounding_rect).to eq(line_path.bounding_rect)

        directions = reversed.svg_subpath.directions
        expect(directions[0]).to be_instance_of(Savage::Directions::MoveTo)
        expect(directions[1]).to be_instance_of(Savage::Directions::LineTo)
        expect(directions[2]).to be_instance_of(Savage::Directions::LineTo)
      end

      it "reverse cw to ccw" do
        reversed = clockwise_triangle_path.reverse

        expect(reversed.start_point).to eq(clockwise_triangle_path.start_point)
        expect(reversed.bounding_rect).to eq(clockwise_triangle_path.bounding_rect)
        expect(reversed.area).to eq(-50)
      end

      it "can reverse path not-ended with Z" do
        reversed = clockwise_not_close.reverse

        expect(reversed.start_point).to eq(clockwise_not_close.start_point)
        expect(reversed.bounding_rect).to eq(clockwise_not_close.bounding_rect)
        expect(reversed.area).to eq(-50)
      end

      it "can reverse arc" do
        reversed = clockwise_arc_path.reverse

        expect(reversed.start_point).to eq(clockwise_arc_path.start_point)
        expect(reversed.area).to be < 0
      end
    end
  end
end
