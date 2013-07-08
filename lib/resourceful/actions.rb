module Resourceful
  ##
  # = Actions
  #
  # Used as a template for all Restful controller actions
  #
  # By default an action is created with an alias method with a bang(!).
  # If you need to override an action, just redefine it in you controller,
  # to call this base action, just call the bang version:
  #
  #   def index
  #     @documents = Document.all
  #     index!
  #   end
  #
  # This will allow you to let Resourceful to continue with the action flow.
  #
  # When overriding an action, just be sure to have inside de action variables
  # with the name of the defined model, doing this will allow you to call the
  # bang action version:
  #
  #   def new
  #     @document = Document.new name: 'Default name'
  #     new!
  #   end
  #
  # For actions like :create and :update a notice or alert can be passed as
  # option to be set in flash object:
  #
  #   def create
  #     @document = Document.new secure_params
  #     create!(notice: 'Hey a new document was created!')
  #   end
  #
  # Also a block can be passed for the happy path to tell the application to
  # where redirect:
  #
  #   def update
  #     @document = Document.find params[:id]
  #     @document.update_attributes secure_params
  #
  #     update!(notice: 'Document has been updated'){ root_path }
  #   end
  #
  # It's also possible to supply a block for the non-happy path, this means
  # proving a dual block for success and failure results from our action:
  #
  #   def update
  #     @document = Document.find params[:id]
  #     @document = update_attributes secure_params
  #
  #     update! do |success, failure|
  #       success.html { redirect_to root_path }
  #       failure.html { render :custom }
  #     end
  #   end
  #
  # Be aware that Resourceful require that your controllers define to what they
  # respond, it could be :html, :json or anything else, just remember to add
  # the respond_to macro to the top of your controller's definition:
  #
  #  class DocumentsController < ApplicationController
  #    respond_to :html
  #  end
  #
  module Actions
    def index(options = {}, &block)
      respond_with(collection, options,  &block)
    end
    alias_method :index!, :index

    def new(options = {}, &block)
      respond_with(build_resource, options, &block)
    end
    alias_method :new!, :new

    def create(options = {}, &block)
      object = get_resource_ivar || create_resource

      options[:location] = collection_path if object.errors.empty?

      respond_with_dual(object, options, &block)
    end
    alias_method :create!, :create

    def edit(options = {}, &block)
      object = get_resource_ivar || find_resource

      respond_with(object, options, &block)
    end
    alias_method :edit!, :edit

    def update(options = {}, &block)
      object = get_resource_ivar || find_and_update_resource

      options[:location] = collection_path if object.errors.empty?

      respond_with_dual(object, options, &block)
    end
    alias_method :update!, :update

    def show(options = {}, &block)
      object = get_resource_ivar || find_resource

      respond_with(object, options, &block)
    end
    alias_method :show!, :show

    def destroy(options = {}, &block)
      object = get_resource_ivar || find_resource

      object.destroy
      options[:location] = collection_path

      respond_with(object, options, &block)
    end
    alias_method :destroy!, :destroy

    protected :index!, :new!, :create!, :edit!, :update!, :show!, :destroy!
  end
end
