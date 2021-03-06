module VectorBeWinding
  module SpatialTree
    def children
      @children ||= []
    end

    def insert_to_tree(node)
      raise "#{node} is same node: " if equal?(node)

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

    def depth
      if children.empty?
        1
      else
        children.map(&:depth).max + 1
      end
    end

    def each &pr
      pr.call(self)
      children.each {|node| node.each(&pr) }
    end

    def dump(indent = 0)
      puts ' ' * (indent * 2) + (area < 0 ? '-' : '+') + inspect
      children.each {|node| node.dump(indent + 1)}
    end
  end
end
