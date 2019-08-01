##
# This module allow to add common tests for a REST controller,
# allowing to eliminate test repetdefions
module BaseActions
  def test_base_actions(base_url: nil, model: nil, with_id: nil, for_params: {}) # rubocop:disable MethodLength, LineLength
    @@base_url = base_url
    @@for_params = for_params
    @@with_id = with_id
    @@model = model

    class_eval do
      def resource
        @@model
      end

      def resources
        resource.to_s.pluralize.to_sym
      end

      def id
        @@with_id
      end

      def valid_params
        @@for_params
      end

      def url
        @@base_url
      end

      def test_render_list
        get url

        assert_response :success
      end

      def test_render_form_when_new
        get "#{url}/new"

        assert_response :success
      end

      def test_redirects_when_created
        post url, params: valid_params

        assert_redirected_to documents_path
      end

      def test_display_errors_when_new_invalid
        invalid_params = generate_invalid_params
        post url, params: invalid_params

        assert_response :success
      end

      def test_render_form_when_edit
        get "#{url}/#{id}/edit"

        assert_response :success
      end

      def test_raise_exception_on_edit_not_found
        assert_raises(ActiveRecord::RecordNotFound) { get "#{url}/1/edit" }
      end

      def test_redirects_when_updated
        params = valid_params.merge id: id
        put "#{url}/#{id}", params: params

        assert_redirected_to documents_path
      end

      def test_display_errors_when_edit_invalid
        invalid_params = generate_invalid_params
        invalid_params[:id] = id
        put "#{url}/#{id}", params: invalid_params

        assert_response :success
      end

      def test_raise_exception_on_updated_not_found
        assert_raises(ActiveRecord::RecordNotFound) { put "#{url}/1" }
      end

      def test_render_show
        get "#{url}/#{id}"

        assert_response :success
      end

      def raise_exception_on_show_not_found
        assert_raises(ActiveRecord::RecordNotFound) { get "#{url}/1" }
      end

      def test_redirects_when_deleted
        delete "#{url}/#{id}"

        assert_redirected_to documents_path
      end

      def raise_exception_on_deleted_not_found
        assert_raises(ActiveRecord::RecordNotFound) { delete "#{url}/1" }
      end

      def generate_invalid_params
        invalid_params = valid_params.deep_dup

        invalid_params.keys.each do |top_key|
          invalid_params[top_key].keys.each do |key|
            invalid_params[top_key][key] = ""
          end
        end

        invalid_params
      end

      protected :generate_invalid_params
    end
  end
end
