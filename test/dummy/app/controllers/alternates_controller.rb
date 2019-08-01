class AlternatesController < BaseController
  include Restful::Base

  respond_to :html
  restful model: :document

  def index
    @documents = Document.all
    index!
  end

  def new
    @document = Document.new
    new!
  end

  def create
    @document = Document.new secure_params
    @document.save
    create!
  end

  def edit
    @document = Document.find params[:id]
    edit!
  end

  def update
    @document = Document.find params[:id]
    @document.update_attributes secure_params
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

  def secure_params
    params.require(:document).permit :name
  end
end
