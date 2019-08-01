require "test_helper"

class CustomNoticesTest < ActionDispatch::IntegrationTest
  def valid_params
    {document: {name: "Sample"}}
  end

  def test_has_a_notice
    post "/custom_notices", params: valid_params

    assert_equal "A new document was created", flash[:notice]
    assert_redirected_to root_path
  end

  def test_has_an_alert
    params = valid_params.merge id: 100
    put "/custom_notices/100", params: params

    assert_equal "There are some errors", flash[:alert]
    assert_redirected_to root_path
  end
end
