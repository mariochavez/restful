module Resourceful
  ##
  # This class acts as a respoder for dual block actions.
  # Since there is no action need it from it, it just implements
  # a method_missing for responder actions that needs to be ignored
  class DummyResponder
    def method_missing(args)
      nil
    end
  end
end
