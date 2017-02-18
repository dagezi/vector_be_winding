require "spec_helper"

module VectorBeWinding
  describe Vector do
    let (:v0) { Vector.new(3, 4) }
    let (:v1) { Vector.new(-4, 3) }

    it "has right dot product" do
      expect(v0 + v1).to eq (Vector.new(-1, 7))
      expect(v0 + -v0).to eq (Vector.new(0, 0))
      expect(v0 - v0).to eq (Vector.new(0, 0))
      expect(v0.dot(v1)).to eq(0)
      expect(v0.norm).to eq(25)
      expect(v0.cross(v1)).to eq(25)
    end
  end
end
