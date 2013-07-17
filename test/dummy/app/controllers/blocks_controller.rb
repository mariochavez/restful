class BlocksController < BaseController
  include Restful::Base

  respond_to :html
  restful model: :document

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

  protected
  def create_secure_params
    params.require(:document).permit :name
  end

  def update_secure_params
    params.require(:document).permit :name
  end
end
