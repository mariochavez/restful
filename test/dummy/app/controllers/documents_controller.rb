class DocumentsController < BaseController
  include Restful::Base

  respond_to :html
  restful model: :document

  protected
  def secure_params
    params.require(:document).permit :name
  end
end
