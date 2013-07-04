module Resourceful
  class DummyResponder
    def method_missing(args)
      nil
    end
  end
end
