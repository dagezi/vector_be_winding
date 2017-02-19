require 'spec_helper'

module VectorBeWinding
  class DummyRect < Rect
    include SpatialTree

    def bounding_rect
      Rect.new(left, top, right, bottom)
    end
  end

  describe "SpatialTree" do
    let (:rect0) { DummyRect.new(10, 10, 100, 100) }
    let (:rect00) { DummyRect.new(10, 10, 50, 50) }
    let (:rect000) { DummyRect.new(40, 40, 50, 50) }

    it "has empty children" do
      expect(rect0.children).to be_empty
      expect(rect00.children).to be_empty
    end

    it "creates right tree" do
      rect0.insert_to_tree(rect00)
      rect0.insert_to_tree(rect000)
      expect(rect0.children).to eq([rect00])
      expect(rect00.children).to eq([rect000])
      expect(rect000.children).to be_empty
    end

    it "insert node into middle" do
      rect0.insert_to_tree(rect000)
      rect0.insert_to_tree(rect00)
      expect(rect0.children).to eq([rect00])
      expect(rect00.children).to eq([rect000])
      expect(rect000.children).to be_empty
    end

  end
end
