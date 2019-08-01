require "test_helper"

class RestfulTest < ActiveSupport::TestCase
  def test_is_a_module
    assert_kind_of Module, Restful
  end
end
