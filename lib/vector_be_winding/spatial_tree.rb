module VectorBeWinding
  module SpatialTree
    def children
      @children ||= []
    end

    def insert_to_tree(node)
      # self must contain the node
      containers = children.select {|n1| n1.contains?(node)}
      if containers.empty?
        components = children.select {|n1| node.contains?(n1)}
        components.each{|n1| children.delete(n1)}
        node.children.concat(components)
        children << node
      else
        containers.first.insert_to_tree(node)
      end
    end

    def dump(indent = 0)
      puts ' ' * (indent * 2) + inspect
      children.each {|node| node.dump(indent + 1)}
    end
  end
end
