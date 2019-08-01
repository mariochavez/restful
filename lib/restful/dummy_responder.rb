module Restful
  ##
  # This class acts as a respoder for dual block actions.
  # Since there is no action need it from it, it just implements
  # a method_missing for responder that needs to be ignored.
  class DummyResponder
    # rubocop:disable Style/MethodMissingSuper
    def method_missing(args) # :nodoc:
      nil
    end
    # rubocop:enable Style/MethodMissingSuper

    def respond_to_missing?(name, include_private) # :nodoc:
      true
    end
  end
end
