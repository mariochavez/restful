require "test_helper"

class Admin::PrefixControllerTest < ActiveSupport::TestCase
  def subject
    controller = Admin::PrefixController.new

    request = ActionDispatch::TestRequest.create
    request.host = "www.example.org"
    controller.request = request

    controller
  end

  def model
    Document.new.tap { |document| document.id = 1 }
  end

  def test_respond_to_edit_path_helper
    assert_match(/^\/admin\//, subject.edit_resource_path(model))
  end

  def test_respond_to_edit_url_helper
    assert_match(/\.org\/admin\//, subject.edit_resource_url(model))
  end

  def test_respond_to_new_path_helper
    assert_match(/^\/admin\//, subject.new_resource_path)
  end

  def test_respond_to_new_url_helper
    assert_match(/\.org\/admin\//, subject.new_resource_url)
  end

  def test_respond_to_collection_path_helper
    assert_match(/^\/admin/, subject.collection_path)
  end

  def test_respond_to_collection_url_helper
    assert_match(/\.org\/admin/, subject.collection_url)
  end
end
