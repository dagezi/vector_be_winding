require "spec_helper"

describe VectorBeWinding::Rect do
  let(:rect0) { VectorBeWinding::Rect.new(2, 2, -1, -1) }
  let(:rect1) { VectorBeWinding::Rect.new(0, 0, 3, 3) }
  let(:rect2) { VectorBeWinding::Rect.new(0, 0, 1, 1) }
  let(:rect3) { VectorBeWinding::Rect.new(50, 50, 100, 100) }

  describe "range_intersectedness" do
    it 'returns correct result' do
      examples = [
        [0, 1, 2, 2, 3],
        [-1, 1, 2, 3, 4],
        [1, 1, 4, 2, 3],
        [1, 2, 3, 1, 3],
        [-1, 3, 4, 1, 2],
        [1, 2, 3, 1, 3]
      ]
      examples.each {|expected, a0, a1, b0, b1|
        res = VectorBeWinding::Rect::range_intersectedness(a0, a1, b0, b1)
        expect(signum(res)).to eq(expected)
      }
    end
  end

  describe "range_containingness" do
    it 'returns correct result' do
      examples = [
        [-1, 2, 3, 1, 4],
        [-1, 1, 3, 2, 4],
        [-1, 2, 4, 1, 3],
        [0, 1, 2, 1, 2],
        [1, 1, 4, 2, 3],
        [0, 1, 4, 1, 3],
        [-1, 1, 2, 1, 3]
      ]
      examples.each {|expected, a0, a1, b0, b1|
        res = VectorBeWinding::Rect::range_containingness(a0, a1, b0, b1)
        expect(signum(res)).to eq(expected)
      }
    end
  end

  describe "new" do
    it 'creates correct rect' do
      expect(rect0.left).to eq(-1)
      expect(rect0.top).to eq(-1)
      expect(rect0.right).to eq(2)
      expect(rect0.bottom).to eq(2)
    end
  end

  describe "|" do
    it 'returns union' do
      r = rect0 | rect1
      expect(r.left).to eq(-1)
      expect(r.top).to eq(-1)
      expect(r.right).to eq(3)
      expect(r.right).to eq(3)
    end
  end

  describe '&'  do
    it 'returns intersection' do
      r = rect0 & rect1
      expect(r.left).to eq(0)
      expect(r.top).to eq(0)
      expect(r.right).to eq(2)
      expect(r.bottom).to eq(2)
    end

    it 'returns nil if no intersection' do
      r = rect0 & rect3
      expect(r).to be_nil
    end
  end
end

