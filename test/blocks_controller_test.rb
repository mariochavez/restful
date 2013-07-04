require 'test_helper'

describe BlocksController do
  let(:valid_params) { { document: { name: 'Sample' } } }

 it 'has one response block' do
   post :create, valid_params

   must_redirect_to root_path
 end

 it 'has two response blocks with success' do
   params = valid_params.merge id: 100
   post :update, params

   must_redirect_to root_path
 end

 it 'has two response blocks with failire' do
   params = valid_params.merge(id: 100).tap do |p|
     p[:document][:name] = ''
   end

   post :update, params

   must_render_template :new
 end
end
