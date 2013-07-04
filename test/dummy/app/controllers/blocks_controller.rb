class BlocksController < BaseController
  include Resourceful::Base

  respond_to :html
  resourceful model: :document, strong_params: ->(params) { params.require(:document).permit :name }

  def create
    create! do |success|
      success.html { redirect_to root_path }
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to root_path }
      failure.html { render :new }
    end
  end
end
