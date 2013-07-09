module Restful
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
  # This will allow you to let Restful to continue with the action flow.
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
  # Be aware that Restful require that your controllers define to what they
  # respond, it could be :html, :json or anything else, just remember to add
  # the respond_to macro to the top of your controller's definition:
  #
  #  class DocumentsController < ApplicationController
  #    respond_to :html
  #  end
  #
  module Actions
    ##
    # index action, this set a collection of objects to an instance variable
    # which can be accessed from the view using the collection helper method.
    # The instance variable name is a pluralization of the model name defined
    # in the restful macro.
    def index(options = {}, &block)
      respond_with(collection, options,  &block)
    end
    alias_method :index!, :index

    ##
    # new action, creates a new object and sets an instance variable which can
    # be accessed from the view using the resource helper method. The instance
    # variable is named after the model name defined in the restful macro.
    def new(options = {}, &block)
      respond_with(build_resource, options, &block)
    end
    alias_method :new!, :new

    ##
    # create action, creates a new object off the received params and sets an
    # instance variable if record is saved then a redirect to index action is
    # made.
    #
    # If record fail to be saved, the new form is renderd and the instance
    # variable can be accessed from the view using the resource
    # helper method. The instance variable is named after the model name
    # defined in the restful macro.
    def create(options = {}, &block)
      object = get_resource_ivar || create_resource

      options[:location] = collection_path if object.errors.empty?

      respond_with_dual(object, options, &block)
    end
    alias_method :create!, :create

    ##
    # edit action, finds an object based on the passed id, if no object is
    # found an ActiveRecord::RecordNotFound is raised.
    #
    # If the record is found then an instance variable, based on the model
    # name set in the restful macro.
    #
    # This variable can be accessed in teh form using the resource helper
    # method.
    def edit(options = {}, &block)
      object = get_resource_ivar || find_resource

      respond_with(object, options, &block)
    end
    alias_method :edit!, :edit

    ##
    # update action, finds an object based on the passed id, if no object is
    # found an ActiveRecord::RecordNotFound is raised. If the record is found
    # then it's updated from params using ActiveRecord update_attributes method
    # and an instance variable is set with the object, variable name is based
    # on the model name set in the restful macro.
    #
    # If update_attributes fail, then edit form is displayed, and the instance
    # variable can be accessed in teh form using the resource helper method.
    #
    # If update_attributes success, a redirect to the index action is made.
    def update(options = {}, &block)
      object = get_resource_ivar || find_and_update_resource

      options[:location] = collection_path if object.errors.empty?

      respond_with_dual(object, options, &block)
    end
    alias_method :update!, :update

    ##
    # show action, finds an object based on the passed id, if no object is
    # found an ActiveRecord::RecordNotFound is raised. If the record is found
    # then an instance variable is set with the object, variable name is based
    # on the model name set in the restful macro.
    def show(options = {}, &block)
      object = get_resource_ivar || find_resource

      respond_with(object, options, &block)
    end
    alias_method :show!, :show

    ##
    # destroy action, finds an object based on the passed id, if no object is
    # found an ActiveRecord::RecordNotFound is raised. If the record is found
    # then it's destroyed and a redirect to the index action is made.
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
