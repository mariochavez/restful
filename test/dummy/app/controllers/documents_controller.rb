class DocumentsController < BaseController
  include Restful::Base

  respond_to :html
  restful model: :document, strong_params: :document_params

  protected
  def document_params
    params.require(:document).permit :name
  end
end
