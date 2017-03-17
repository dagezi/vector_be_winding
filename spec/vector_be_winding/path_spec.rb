require 'spec_helper'

def box_cw(size)
  "M-#{size},-#{size}L#{size},-#{size}L#{size},#{size}L-#{size},#{size}Z"
end

def box_ccw(size)
  "M-#{size},-#{size}L-#{size},#{size}L#{size},#{size}L#{size},-#{size}Z"
end

module VectorBeWinding
  describe Path do
    let (:path_single) { Path.with_string('M10,10L5,20Z') }
    let (:path_2subpath) { Path.with_string('M10,10L5,20ZM30,20v10h10Z') }
    let (:path_cw_cw) { Path.with_string(box_cw(5) + box_cw(10))}
    let (:path_cw_ccw) { Path.with_string(box_ccw(5) + box_cw(10))}
    let (:path_cw_cw_cw) { Path.with_string(box_cw(5) + box_cw(10) + box_cw(15))}

    it 'can parse' do
      expect(path_single.sub_paths.count).to eq(1)
      expect(path_2subpath.sub_paths.count).to eq(2)
      expect(path_cw_cw.sub_paths.count).to eq(2)
      expect(path_cw_cw_cw.sub_paths.count).to eq(3)
    end

    it 'can return right bounding_rect' do
      expect(path_single.bounding_rect).to eq(Rect.new(5, 10, 10, 20))
      expect(path_2subpath.bounding_rect).to eq(Rect.new(5, 10, 40, 30))
      expect(path_cw_cw_cw.bounding_rect).to eq(Rect.new(-15, -15, 15, 15))
    end

    it 'has right spatial tree' do
      expect(path_cw_cw_cw.depth).to be 4
      expect(path_cw_cw.depth).to be 3
    end

    it 'has correct area' do
      expect(path_cw_cw.area).to be_within(0.1).of(500)
      expect(path_cw_ccw.area).to be_within(0.1).of(300)
      expect(path_cw_cw_cw.area).to be_within(0.1).of(1400)
    end

    describe "is_winding" do
      it 'detect if it\'s widing or not' do
        expect(path_cw_cw.is_winding).to be_falsey
        expect(path_cw_ccw.is_winding).to be_truthy
        expect(path_cw_cw_cw.is_winding).to be_falsey
      end
    end

    describe "be_winding" do
      it 'changes the direction of inner box' do
        wound = path_cw_cw.be_winding
        expect(wound.depth).to be 3
        expect(wound.bounding_rect).to eq(path_cw_cw.bounding_rect)
        expect(wound.area).to be_within(0.1).of(300)
      end

      it 'keeps the direction of innermost box' do
        wound = path_cw_cw_cw.be_winding
        expect(wound.depth).to be 4
        expect(wound.bounding_rect).to eq(path_cw_cw_cw.bounding_rect)
        expect(wound.area).to be_within(0.1).of(30 * 30 - 20 * 20 + 10 * 10)
      end
    end
  end
end
