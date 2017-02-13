$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "vector_be_winding"

def signum(a)
  if a == 0 then 0 elsif a < 0 then -1 else 1 end
end
