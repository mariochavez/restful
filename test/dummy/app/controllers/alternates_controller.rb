class AlternatesController < BaseController
  include Resourceful::Base

  respond_to :html
  resourceful model: :document, strong_params: :document_params

  def index
    @documents = Document.all
    index!
  end

  def new
    @document = Document.new
    new!
  end

  def create
    @document = Document.new document_params
    @document.save
    create!
  end

  def edit
    @document = Document.find params[:id]
    edit!
  end

  def update
    @document = Document.find params[:id]
    @document.update_attributes document_params
    update!
  end

  def show
    @document = Document.find params[:id]
    show!
  end

  def destroy
    @document = Document.find params[:id]
    @document.destroy
    destroy!
  end

  protected
  def document_params
    params.require(:document).permit :name
  end
end
