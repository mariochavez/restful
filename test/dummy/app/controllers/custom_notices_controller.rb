class CustomNoticesController < BaseController
  include Resourceful::Base

  respond_to :html
  resourceful model: :document, strong_params: ->(params) { params.require(:document).permit :name }

  def create
    create!(notice: 'A new document was created') { root_url }
  end

  def update
    update!(alert: 'There are some errors') { root_url }
  end
end
