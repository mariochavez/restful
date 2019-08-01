class CustomNoticesController < BaseController
  include Restful::Base

  respond_to :html
  restful model: :document

  def create
    create!(notice: "A new document was created") { root_url }
  end

  def update
    update!(alert: "There are some errors") { root_url }
  end

  protected

  def secure_params
    params.require(:document).permit :name
  end
end
