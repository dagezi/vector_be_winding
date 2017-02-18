require "spec_helper"

module VectorBeWinding
  describe SubPath do
    it "can parse 'L5,20Z' " do
      sub_path = SubPath.with_string('L5,20Z')
      expect(sub_path.start_point).to eq(Vector.new(0, 0))
      expect(sub_path.bounding_rect).to eq(Rect.new(0, 0, 5, 20))
    end

    it "can parse 'M10,10L20,20Z'" do
      sub_path = SubPath.with_string('M10,10L20,20Z')
      expect(sub_path.start_point).to eq(Vector.new(10, 10))
      expect(sub_path.segments.count).to eq(2)
      expect(sub_path.segments[0].end_point).to eq(Vector.new(20, 20))
      expect(sub_path.segments[1].end_point).to eq(Vector.new(10, 10))
      expect(sub_path.bounding_rect).to eq(Rect.new(10, 10, 20, 20))
    end
  end
end
