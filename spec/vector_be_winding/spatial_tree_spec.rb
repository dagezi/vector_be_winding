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
    let (:rect10) { DummyRect.new(60, 10, 80, 30) }

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

    describe "each" do
      it "travese all nodes" do
        rect0.insert_to_tree(rect000)
        rect0.insert_to_tree(rect00)
        rect0.insert_to_tree(rect10)

        nodes = []
        rect0.each {|node| nodes << node }
        expect(nodes).to contain_exactly(rect0, rect00, rect000, rect10)
      end
    end
  end
end
