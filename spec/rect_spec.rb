Urequire "spec_helper"

describe VectorBeWinding::Rect do

  describe "rect" do
    describe "range_intersectedness" do
      it 'returns correct result' do
        examples = [
          [0, 1, 2, 2, 3],
          [-1, 1, 2, 3, 4],
          [1, 1, 4, 2, 3],
          [1, 2, 3, 1, 3],
          [0, 1, 2, 3, 2],
          [-1, 4, 3, 2, 1],
          [1, 3, 2, 1, 3]
        ]
        examples.each {|expected, a0, a1, b0, b1|
          res = VectorBeWinding::Rect::range_intersectedness(a0, a1, b0, b1)
          expect(signum(res)).to eq(expected)
        }
      end
    end
  end
end

