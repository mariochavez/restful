##
# This module allow to add common tests for a REST controller,
# allowing to eliminate test repetitions
module BaseActions
  def test_base_actions(base_url: nil, model: nil, with_id: nil, for_params: {}) # rubocop:disable MethodLength, LineLength
    self.class_eval do
      let(:base_url) { base_url }
      let(:resource) { model }
      let(:resources) { model.to_s.pluralize.to_sym }
      let(:id) { with_id }
      let(:valid_params) { for_params }

      context 'base actions' do
        context 'index' do
          it 'render list' do
            get base_url

            must_respond_with :success
          end
        end

        context 'new' do
          it 'render form' do
            get "#{base_url}/new"

            must_respond_with :success
          end
        end

        context 'create' do
          it 'redirects' do
            post "#{base_url}", params: valid_params

            must_redirect_to documents_path
          end

          it 'display errors' do
            invalid_params = generate_invalid_params
            post "#{base_url}", params: invalid_params

            must_respond_with :success
          end
        end

        context 'edit' do
          it 'render form' do
            get "#{base_url}/#{id}/edit"

            must_respond_with :success
          end

          it 'raise exception on not found' do
            proc { get "#{base_url}/1/edit" }
            .must_raise ActiveRecord::RecordNotFound
          end
        end

        context 'update' do
          it 'redirects' do
            params = valid_params.merge id: id
            put "#{base_url}/#{id}", params: params

            must_redirect_to documents_path
          end

          it 'display errors' do
            invalid_params = generate_invalid_params
            invalid_params.merge! id: id
            put "#{base_url}/#{id}", params: invalid_params

            must_respond_with :success
          end

          it 'raise exception on not found' do
            proc { put "#{base_url}/1" }
              .must_raise ActiveRecord::RecordNotFound
          end
        end

        context 'show' do
          it 'render view' do
            get "#{base_url}/#{id}"

            must_respond_with :success
          end

          it 'raise exception on not found' do
            proc { get "#{base_url}/1" }
              .must_raise ActiveRecord::RecordNotFound
          end
        end

        context 'destroy' do
          it 'redirects' do
            delete "#{base_url}/#{id}"

            must_redirect_to documents_path
          end

          it 'raise exception on not found' do
            proc { delete "#{base_url}/1" }
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
