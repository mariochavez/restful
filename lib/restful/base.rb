module Restful
  ##
  # This is the main module for Restful implementation, in here class
  # methods that implement the configuration macro that need to be included in
  # controllers is defined.
  #
  # Also in this module exists the definition of instance methods need it by
  # the actions injected to a controller.
  module Base
    ##
    # Through this method, when this module is included in a controller, all
    # Restful functionality is defined for it.
    def self.included(base)
      base.extend ClassMethods
    end

    ##
    # Instance helper methods for a Restful controller
    module InstanceMethods
      ##
      # Helper method that allows you to refer to the instance variable that
      # represent a single object from the model name defined in the restful
      # macro.
      def resource
        get_resource_ivar
      end

      ##
      # Helper method that allows you to refer to the instance variable that
      # represents the collection of objects from the model name defined in the
      # restful macro.
      def collection
        get_collection_ivar || begin
          set_collection_ivar class_name.all
        end
      end

      ##
      # Helper method that gives you access to the class of your model.
      def resource_class
        class_name
      end

      ##
      # Generic route path helper method to edit a model.
      def edit_resource_path(object)
        send route_prefix_to_method_name("edit_#{class_name.model_name.singular_route_key}_path"),
          object
      end

      ##
      # Generic route url helper method to edit a model.
      def edit_resource_url(object)
        send route_prefix_to_method_name("edit_#{class_name.model_name.singular_route_key}_url"),
          object
      end

      ##
      # Generic route path helper method for new model.
      def new_resource_path
        send route_prefix_to_method_name("new_#{class_name.model_name.singular_route_key}_path")
      end

      ##
      # Generic route url helper method for new model.
      def new_resource_url
        send route_prefix_to_method_name("new_#{class_name.model_name.singular_route_key}_url")
      end

      ##
      # This is a helper method to get the object collection path.
      def collection_path
        send route_prefix_to_method_name("#{class_name.model_name.route_key}_path")
      end

      ##
      # This is a helper method to get the object collection url.
      def collection_url
        send route_prefix_to_method_name("#{class_name.model_name.route_key}_url")
      end

      protected

      ##
      # Return a url helper method name with additional route prefix if set.
      # If route_prefix param is set to `admin` then the method name will be:
      #
      #   edit_resource_path => admin_edit_resource_path
      #
      def route_prefix_to_method_name(method)
        "#{route_prefix + "_" if route_prefix}#{method}"
      end

      ##
      # Return the instance variable name for a single object based on the model
      # name defined in the restful macro, example:
      #
      #   @document
      def resource_ivar
        "@#{class_name.model_name.singular}"
      end

      ##
      # Return the instance variable name for a collection of objects based on
      # the model name defined in the restful macro, example:
      #
      #   @documents
      def collection_ivar
        "@#{class_name.model_name.plural}"
      end

      ##
      # Get the object from a single object instance variable.
      def get_resource_ivar # rubocop:disable Naming/AccessorMethodName
        instance_variable_get resource_ivar
      end

      ##
      # Set the instance variable for a single object with an object.
      #
      # ==== Params
      # * object: The object to be stored in the instance variable.
      def set_resource_ivar(object) # rubocop:disable Naming/AccessorMethodName
        instance_variable_set resource_ivar, object
      end

      ##
      # Get the collection of objects from an instance variable.
      def get_collection_ivar # rubocop:disable Naming/AccessorMethodName
        instance_variable_get collection_ivar
      end

      ##
      # Set the instance variable for a collection of objects
      #
      # ==== Params
      # * objects: The objects collections to be stored in the instance
      # variable.
      def set_collection_ivar(objects) # rubocop:disable Naming/AccessorMethodName
        instance_variable_set collection_ivar, objects
      end

      ##
      # Get an object from instance variable if it exists, if not then build
      # a new object.
      def build_resource
        get_resource_ivar || begin
          set_resource_ivar class_name.new
        end
      end

      ##
      # Creates a new object using request params, tries to save the object and
      # set it to the object's instance variable.
      def create_resource
        class_name.new(get_secure_params).tap do |model|
          model.save
          set_resource_ivar model
        end
      end

      ##
      # Calls template methods for getting params curated by strong params
      # This method calls to a 3 different hook methods in the controller.
      # First depending on the action :create or :update the controller is
      # tested to have a create_secure_params or update_secure_params method,
      # if method is not present then it tries with a generic method
      # secure_params.
      #
      # If no template method is implemented in the controller then
      # a NotImplementedError exception is raised.
      def get_secure_params # rubocop:disable Naming/AccessorMethodName
        params_method = "#{action_name}_secure_params".to_sym

        filterd_params =
          (send(params_method) if respond_to?(params_method, true)) ||
          (send(:secure_params) if respond_to?(:secure_params, true))

        unless filterd_params
          raise NotImplementedError,
            "You need to define template methods for strong params"
        end

        filterd_params
      end

      ##
      # This is a special method used by create and update actions that allows
      # these methods to receive two blocks, success and failure blocks.
      def respond_with_dual(object, options, &block)
        args = [object, options]
        set_flash options

        case block.try(:arity)
        when 2
          respond_with(*args) do |responder|
            dummy_responder = Restful::DummyResponder.new

            if get_resource_ivar.errors.empty?
              block.call responder, dummy_responder
            else
              block.call dummy_responder, responder
            end
          end
        when 1
          respond_with(*args, &block)
        else
          options[:location] = block.call if block
          respond_with(*args)
        end
      end

      ##
      # This method set the flash messages if they are passed within the action
      # ==== Params
      # * options: a hash with :notice or :alert messages
      def set_flash(options = {}) # rubocop:disable Naming/AccessorMethodName
        if options.key?(:notice)
          flash[:notice] = options[:notice]
        elsif options.key?(:alert)
          flash[:alert] = options[:alert]
        end
      end

      ##
      # Find an object using the param id and set the object to the instance
      # variable.
      def find_resource
        set_resource_ivar class_name.find(params[:id])
      end

      ##
      # Find an object, update attributes from params and set instance
      # variable.
      def find_and_update_resource
        model = class_name.find(params[:id])
        model.tap do |m|
          m.update get_secure_params
          set_resource_ivar m
        end
      end
    end

    ##
    # Class macros to setup restful functionality
    module ClassMethods
      ##
      # List of REST actions
      ACTIONS = [:index, :show, :edit, :update, :new, :create, :destroy]

      ##
      # Restful is the macro that setup a controller to become restful.
      # This macro accepts 3 params:
      #
      # ==== Params
      # * model: A required parameter which is a symbol of the model name.
      # * route_prefix: A prefix string to be used with controller's url
      # helper.
      # * actions: An array of actions that a controller should implement, if
      # none is passed then all seven REST actions are defined.
      #
      # ==== Examples
      #
      # Simple:
      #
      #   class DocumentsController < ApplicationController
      #     include Restful::Base
      #     respond_to :html
      #
      #     restful model: :document
      #   end
      #
      # This definition will create the seven REST actions for Document model,
      # this setup a single object instance variable @document and a collection
      # variable @documents.
      #
      # Route prefix:
      #
      #   class DocumentsController < ApplicationController
      #     include Restful::Base
      #     respond_to :html
      #
      #     restful model: :document, route_prefix: 'admin'
      #   end
      #
      # With *route_prefix* param every URL helper method in our controller
      # will have the defined prefix.
      #
      # `edit_resource_path` helper method will call internally
      # `admin_edit_resource_path`.
      #
      # Listed actions variation:
      #
      # The last parameter *actions* allows you to list in an array the actions
      # that you want your controller to have:
      #
      #   class DocumentsController < ApplicationController
      #     include Restful::Base
      #     respond_to :html
      #
      #     restful model: :document, actions: [:index, :show]
      #   end
      #
      # In this case our controller will only respond to those 2 actions. We
      # can do it the other way, indicate list of actions that shouldn't be
      # defined:
      #
      #   class DocumentsController < ApplicationController
      #     include Restful::Base
      #     respond_to :html
      #
      #     restful model: :document, actions: [:all, except: [:destroy, :show]]
      #   end
      #
      # For this last example all seven REST actions will be defined but
      # :destroy and :show
      #
      # Strong params
      # Restful provides 3 hooks for you to implement in your controller, two
      # of these hooks will be called depending on the action that is being
      # executed: :create_secure_params and :update_secure_params.
      #
      # if you don't require a specific strong params definition for each
      # action, then just implement :secure_params method and this will be
      # called.
      #
      # ==== Considerations
      # From previous examples you must have notice by now that the respond_to
      # macro es need it. This is because all REST actions call the
      # respont_with method, which works with the respond_to macro. Just
      # include it in your controllers and list the formats do you wish your
      # controller to respond.
      #
      def restful(model: nil, route_prefix: nil, actions: :all)
        class_attribute :model_name, :class_name, :route_prefix,
          instance_writer: false

        self.model_name = model
        self.class_name = class_from_name
        self.route_prefix = route_prefix

        include InstanceMethods
        include Restful::Actions

        setup_actions actions unless actions == :all

        if respond_to?(:helper_method)
          helper_method :collection, :resource, :resource_class,
            :edit_resource_path, :edit_resource_url, :new_resource_path,
            :new_resource_url, :collection_path, :collection_url

        end
      end

      protected

      ##
      # Method that calculates the actions to which our controller should
      # respond to.
      def setup_actions(actions)
        keep_actions = actions

        if actions.include?(:all)
          keep_actions = ACTIONS
        end

        options = actions.extract_options!
        except_actions = options[:except] || []
        keep_actions -= except_actions

        (ACTIONS - keep_actions).uniq.each do |action|
          undef_method action.to_sym, "#{action.to_sym}!"
        end
      end

      ##
      # Method that gets the model class name from the passed symbol.
      def class_from_name
        if model_name.to_s.include? "_"
          ns, *klass = model_name.to_s.split("_").collect(&:camelize)
          begin
            "#{ns}::#{klass.join("")}".constantize
          rescue NameError
            "#{ns}#{klass.join("")}".constantize
          end
        else
          model_name.to_s.camelize.constantize
        end
      end
    end
  end
end
