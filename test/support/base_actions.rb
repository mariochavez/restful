##
# This module allow to add common tests for a REST controller,
# allowing to eliminate test repetitions
module BaseActions
  def test_base_actions(model: nil, with_id: nil, for_params: {}) # rubocop:disable MethodLength, LineLength
    self.class_eval do
      let(:resource) { model }
      let(:resources) { model.to_s.pluralize.to_sym }
      let(:id) { with_id }
      let(:valid_params) { for_params }

      context 'base actions' do
        context 'index' do
          it 'render list' do
            get :index

            must_respond_with :success
            must_render_template :index
            assigns[resources].wont_be_nil
          end
        end

        context 'new' do
          it 'render form' do
            get :new

            must_respond_with :success
            must_render_template :new
            assigns[resource].wont_be_nil
          end
        end

        context 'create' do
          it 'redirects' do
            post :create, valid_params

            must_redirect_to documents_path
          end

          it 'display errors' do
            invalid_params = generate_invalid_params
            post :create, invalid_params

            must_respond_with :success
            must_render_template :new
            assigns[resource].wont_be_nil
          end
        end

        context 'edit' do
          it 'render form' do
            get :edit, id: id

            must_respond_with :success
            must_render_template :edit
            assigns[resource].wont_be_nil
          end

          it 'raise exception on not found' do
            proc { get :edit, id: 1 }
            .must_raise ActiveRecord::RecordNotFound
          end
        end

        context 'update' do
          it 'redirects' do
            params = valid_params.merge id: id
            put :update, params

            must_redirect_to documents_path
          end

          it 'display errors' do
            invalid_params = generate_invalid_params
            invalid_params.merge! id: id
            put :update, invalid_params

            must_respond_with :success
            must_render_template :edit
            assigns[resource].wont_be_nil
          end

          it 'raise exception on not found' do
            proc { put :update, id: 1 }
              .must_raise ActiveRecord::RecordNotFound
          end
        end

        context 'show' do
          it 'render view' do
            get :show, id: id

            must_respond_with :success
            must_render_template :show
            assigns[resource].wont_be_nil
          end

          it 'raise exception on not found' do
            proc { get :show, id: 1 }
              .must_raise ActiveRecord::RecordNotFound
          end
        end

        context 'destroy' do
          it 'redirects' do
            delete :destroy, id: id

            must_redirect_to documents_path
          end

          it 'raise exception on not found' do
            proc { delete :destroy, id: 1 }
              .must_raise ActiveRecord::RecordNotFound
          end
        end

        def generate_invalid_params # rubocop:disable EmptyLineBetweenDefs
          invalid_params = valid_params.deep_dup
          invalid_params.keys.each do |top_key|
            invalid_params[top_key].keys.each do |key|
              invalid_params[top_key][key] = ''
            end
          end
          invalid_params
        end
        protected :generate_invalid_params
      end
    end
  end
end
