require 'test_helper'

describe Resourceful do
  it 'is a module' do
    Resourceful.must_be_kind_of Module
  end
end

describe DocumentsController do
  context 'base actions' do
    context 'index' do
      it 'render list' do
        get :index

        must_respond_with :success
        must_render_template :index
        assigns[:documents].wont_be_nil
      end
    end

    context 'new' do
      it 'render form' do
        get :new

        must_respond_with :success
        must_render_template :new
        assigns[:document].wont_be_nil
      end
    end

    context 'create' do
      it 'redirects' do
        post :create, document: { name: 'New document' }

        must_redirect_to documents_path
      end

      it 'display errors' do
        post :create, document: { name: '' }

        must_respond_with :success
        must_render_template :new
        assigns[:document].wont_be_nil
      end
    end

    context 'edit' do
      it 'render form' do
        get :edit, id: 100

        must_respond_with :success
        must_render_template :edit
        assigns[:document].wont_be_nil
      end

      it 'raise exception on not found' do
        Proc.new{ get :edit, id: 1 }.must_raise ActiveRecord::RecordNotFound
      end
    end

    context 'update' do
      it 'redirects' do
        put :update, id: 100, document: { name: 'New document' }

        must_redirect_to documents_path
      end

      it 'display errors' do
        put :update, id: 100, document: { name: '' }

        must_respond_with :success
        must_render_template :edit
        assigns[:document].wont_be_nil
      end

      it 'raise exception on not found' do
        Proc.new{ put :update, id: 1 }.must_raise ActiveRecord::RecordNotFound
      end
    end

    context 'show' do
      it 'render view' do
        get :show, id: 100

        must_respond_with :success
        must_render_template :show
        assigns[:document].wont_be_nil
      end

      it 'raise exception on not found' do
        Proc.new{ get :show, id: 1 }.must_raise ActiveRecord::RecordNotFound
      end
    end

    context 'destroy' do
      it 'redirects' do
        delete :destroy, id: 100

        must_redirect_to documents_path
      end

      it 'raise exception on not found' do
        Proc.new{ delete :destroy, id: 1 }.must_raise ActiveRecord::RecordNotFound
      end
    end
  end
end
