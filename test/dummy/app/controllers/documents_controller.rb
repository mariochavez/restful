class DocumentsController < ApplicationController
  include Resourceful::Base

  respond_to :html
  resourceful model: :document, strong_params: :document_params

  protected
  def document_params
    params.require(:document).permit :name
  end
end
