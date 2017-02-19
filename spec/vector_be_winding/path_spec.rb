require 'spec_helper'

module VectorBeWinding
  describe Path do
    let (:path_single) { Path.with_string('M10,10L5,20Z') }
    let (:path_2subpath) { Path.with_string('M10,10L5,20ZM30,20v10h10Z') }

    it 'can parse' do
      expect(path_single.sub_paths.count).to eq(1)
      expect(path_2subpath.sub_paths.count).to eq(2)
    end

    it 'can return right bounding_rect' do
      expect(path_single.bounding_rect).to eq(Rect.new(5, 10, 10, 20))
      expect(path_2subpath.bounding_rect).to eq(Rect.new(5, 10, 40, 30))
    end
  end
end
