require 'test_helper'

describe CustomNoticesController do
  let(:valid_params) { { document: { name: 'Sample' } } }

  context 'flash messages' do
    it 'has a notice' do
      post "/custom_notices", params: valid_params

      flash[:notice].must_equal 'A new document was created'
      must_redirect_to root_path
    end

    it 'has an alert' do
      params = valid_params.merge id: 100
      put "/custom_notices/100", params: params

      flash[:alert].must_equal 'There are some errors'
      must_redirect_to root_path
    end
  end
end
