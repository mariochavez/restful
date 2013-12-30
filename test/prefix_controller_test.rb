require 'test_helper'

describe 'Route prefixes' do

  describe Admin::PrefixController do
    subject {
      controller = Admin::PrefixController.new

      request = ActionController::TestRequest.new
      request.host = "www.example.org"
      controller.request = request
      controller
    }

    let(:model) { Document.new.tap{|document| document.id = 1} }

    it 'respond to edit path helper' do
      subject.edit_resource_path(model).must_match /^\/admin\//
    end

    it 'respond to edit url helper' do
      subject.edit_resource_url(model).must_match /\.org\/admin\//
    end

    it 'respond to new path helper' do
      subject.new_resource_path.must_match /^\/admin\//
    end

    it 'respond to new url helper' do
      subject.new_resource_url.must_match /\.org\/admin\//
    end

    it 'respond to collection path helper' do
      subject.collection_path.must_match /^\/admin/
    end

    it 'respond to collection url helper' do
      subject.collection_url.must_match /\.org\/admin/
    end
  end


end
