module VectorBeWinding
  class Shape
    # Each subclass must override it
    def bounding_rect
      raise 'implment this'
    end

    def intersects?(shape1)
      intersectedness(shape1) >= 0
    end

    # Very naive definition. Each subclass is expected to override it
    # negative: no intersected, 0: touched, positive: intersected
    def intersectedness(shape1)
      bounding_rect.intersectedness(shape1.bounding_rect)
    end

    def contains?(shape1)
      containingness(shape1) >= 0
    end

    # Very naive definition. Each subclass is expected to override it
    # negative: no containing, 0: containing with border, positive: inside
    def containingness(shape1)
      bounding_rect.containingness(shape1.bounding_rect)
    end
  end  
end
