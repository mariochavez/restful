require "test_helper"

class BlocksTest < ActionDispatch::IntegrationTest
  def valid_params
    {document: {name: "Sample"}}
  end

  def test_has_one_response_block
    post "/blocks", params: valid_params

    assert_redirected_to root_path
  end

  def test_has_two_response_blocks_with_success
    params = valid_params.merge id: 100
    post "/blocks", params: params

    assert_redirected_to root_path
  end

  def test_has_two_response_blocks_with_failire
    params = valid_params.merge(id: 100).tap do |p|
      p[:document][:name] = ""
    end

    post "/blocks", params: params

    assert_response :success
  end
end
