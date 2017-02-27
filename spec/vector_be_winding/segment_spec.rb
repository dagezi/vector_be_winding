require "spec_helper"

module VectorBeWinding
  describe Segment do
    let (:start_point) { Vector.new(3, 4) }
    let (:end_point)   { Vector.new(5, 6) }
    let (:segment_l) { Segment.new(Savage::Directions::LineTo.new(1, 2, false),
                                   start_point, end_point) }
    let (:segment_z) { Segment.new(Savage::Directions::ClosePath.new(),
                                   start_point, end_point) }

    describe "Segment for line" do
      it "has write end point" do
        expect(segment_l.end_point).to eq(Vector.new(4, 6))
      end

      it "calculates reverse segment" do
        r = segment_l.reverse
        expect(r.start_point).to eq(segment_l.end_point)
        expect(r.end_point).to eq(segment_l.start_point)
      end
    end

    describe "Segment for close path" do
      it "has the sub path's start point as end point" do
        expect(segment_z.end_point).to eq(end_point)
      end

      it "calculates reverse segment" do
        r = segment_z.reverse
        expect(r.start_point).to eq(segment_z.end_point)
        expect(r.end_point).to eq(segment_z.start_point)
      end
    end
  end
end
