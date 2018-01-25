require "spec_helper"

def reversed?(rev, orig)
  expect(rev.start_point).to eq(orig.end_point)
  expect(rev.end_point).to eq(orig.start_point)
end

module VectorBeWinding
  describe Segment do
    let (:start_point) { Vector.new(3, 4) }
    let (:end_point)   { Vector.new(5, 6) }
    let (:segment_s) { Segment.new(Savage::Directions::CubicCurveTo.new(
                                     12, 8, 12, 4, true),
                                   segment_c.end_point, end_point, segment_c) }

    describe "Segment for line" do
      let (:segment_l) { Segment.new(Savage::Directions::LineTo.new(1, 2, false),
                                     start_point, end_point) }

      it "has write end point" do
        expect(segment_l.end_point).to eq(Vector.new(4, 6))
      end

      it "calculates reverse segment" do
        reversed = segment_l.reverse
        reversed?(reversed, segment_l)
        expect(reversed.direction).to be_an_instance_of(::Savage::Directions::LineTo)
      end

      it "calculates signed area" do
        expect(segment_l.area(start_point)).to eq(0)
        expect(segment_l.area(segment_l.end_point)).to eq(0)
        expect(segment_l.area(Vector.new(3, 6))).to eq(1)  # CW
        expect(segment_l.area(Vector.new(4, 4))).to eq(-1) # CCW
      end
    end

    describe "Segment for vetical line" do
      let (:segment_v) { Segment.new(Savage::Directions::VerticalTo.new(2, false),
                                     start_point, end_point) }

      it "has write end point" do
        expect(segment_v.end_point).to eq(Vector.new(3, 6))
      end

      it "calculates reverse segment" do
        reversed = segment_v.reverse
        reversed?(reversed, segment_v)
        expect(reversed.direction).to be_an_instance_of(::Savage::Directions::VerticalTo)
      end
    end

    describe "Segment for close path" do
      let (:segment_z) { Segment.new(Savage::Directions::ClosePath.new(),
                                     start_point, end_point) }

      it "has the sub path's start point as end point" do
        expect(segment_z.end_point).to eq(end_point)
      end

      it "calculates reverse segment" do
        reversed?(segment_z.reverse, segment_z)
      end
    end

    let (:segment_q) { Segment.new(Savage::Directions::QuadraticCurveTo.new(
                                     4, 8, 11, 12, true),
                                   start_point, end_point)}

    describe "Segment for absolute quadratic curve" do
      it "calculates signed area" do
        expect(segment_q.area(segment_q.start_point)).to be < 0
      end

      it "calculates reverse segment" do
        r = segment_q.reverse
        reversed?(r, segment_q)
        expect(r.direction).to be_instance_of(Savage::Directions::QuadraticCurveTo)
        expect(r.control).to eq(segment_q.control)
        expect(r.area(r.start_point)).to be > 0
      end
    end

    describe "Segment for short-cut quadratic curve" do
      let (:segment_t) { Segment.new(Savage::Directions::QuadraticCurveTo.new(
                                       15, 12, true),
                                     segment_q.end_point, end_point, segment_q)}

      it "has derived control point" do
        expect(segment_t.control).to eq(Vector.new(18, 16))
      end
    end

    ##                    1 1 1 1 1 1
    ##    2 3 4 5 6 7 8 9 0 1 2 3 4 5
    ##  3 . . . . . . . . . . . . . .
    ##  4 . S . . . . . . . . E . . .
    ##  5 . . . . . . . . . . . . . .
    ##  6 . . . . . . . . . . . . . .
    ##  7 . . . . . . . . . . . . . .
    ##  8 . . C . . . . . . . C . . .
    ##  9 . . . . . . . . . . . . . .
    ## 10 . . . . . . . . . . . . . .
    ## 11 . . . . . . . . . . . . . .
    ## 12 . . . . . . C . . E . . C .
    ## 13 . . . . . . . . . . . . . .

    let (:segment_c) { Segment.new(Savage::Directions::CubicCurveTo.new(
                                     4, 8, 8, 12, 11, 12, true),
                                   start_point, end_point) }

    describe "Segment for absolute cubic curve" do
      it "calculates signed area" do
        # not so correct. only sign
        expect(segment_c.area(segment_c.start_point)).to be < 0
      end

      it "calculates reverse segment" do
        r = segment_c.reverse
        reversed?(r, segment_c)
        expect(r.control).to eq(segment_c.control_1)
        expect(r.control_1).to eq(segment_c.control)
        expect(r.area(r.start_point)).to be > 0
      end
    end

    describe "Segment for short-cut cubic curve" do
      let (:segment_s) { Segment.new(Savage::Directions::CubicCurveTo.new(
                                       12, 8, 12, 4, true),
                                     segment_c.end_point, end_point, segment_c) }

      it "has correct coordinate" do
        expect(segment_s.start_point).to eq(Vector.new(11, 12))
        expect(segment_s.control_1).to eq(Vector.new(14, 12))
        expect(segment_s.control_2).to eq(Vector.new(12, 8))
        expect(segment_s.end_point).to eq(Vector.new(12, 4))
      end
    end

    describe "Segment for relative cubic curve" do
      let (:segment_rc) { Segment.new(Savage::Directions::CubicCurveTo.new(
                                        1, 4, 5, 8, 8, 8, false),
                                      start_point, end_point) }

      it "has absolute corrdinate" do
        expect(segment_rc.control_1).to eq(Vector.new(4, 8))
        expect(segment_rc.control_2).to eq(Vector.new(8, 12))
      end

      it "calculates signed area" do
        # not so correct. only sign
        expect(segment_rc.area(segment_c.start_point)).to be < 0
      end

      it "calculates reversed segment" do
        r = segment_rc.reverse
        reversed?(r, segment_rc)
        expect(r.control).to eq(segment_rc.control_1)
        expect(r.control_1).to eq(segment_rc.control)
        expect(r.area(r.start_point)).to be > 0
      end
    end

    describe "Segment for arc" do
      let (:segment_a) { Segment.new(Savage::Directions::ArcTo.new(
                                       5, 5, 100, false, false, end_point.x, end_point.y, true),
                                     start_point, end_point) }
      it "calculates signed area" do
        # not so correct, only sign matters
        expect(segment_a.area(start_point)).to be < 0
      end

      it "reverses" do
        r = segment_a.reverse
        reversed?(r, segment_a)
        expect(r.radius).to eq(segment_a.radius)
        expect(r.area(start_point)).to be > 0
      end
    end
  end
end
