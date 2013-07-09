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

      protected
      ##
      # Return the instance variable name for a single object based on the model
      # name defined in the restful macro, example:
      #
      #   @document
      def resource_ivar
        "@#{class_name.model_name.element}"
      end

      ##
      # Return the instance variable name for a collection of objects based on
      # the model name defined in the restful macro, example:
      #
      #   @documents
      def collection_ivar
        "@#{class_name.model_name.collection}"
      end

      ##
      # Get the object from a single object instance variable.
      def get_resource_ivar
        instance_variable_get resource_ivar
      end

      ##
      # Set the instance variable for a single object with an object.
      #
      # ==== Params
      # * object: The object to be stored in the instance variable.
      def set_resource_ivar(object)
        instance_variable_set resource_ivar, object
      end

      ##
      # Get the collection of objects from an instance variable.
      def get_collection_ivar
        instance_variable_get collection_ivar
      end

      ##
      # Set the instance variable for a collection of objects
      #
      # ==== Params
      # * objects: The objects collections to be stored in the instance
      # variable.
      def set_collection_ivar(objects)
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
        class_name.new(secure_params).tap do |model|
          model.save
          set_resource_ivar model
        end
      end

      ##
      # Apply Strong Params, using a string or symbol for method name or a Proc
      # given to the restful macro.
      def secure_params
        return params unless strong_params.present?

        if strong_params.is_a?(Symbol) || strong_params.is_a?(String)
          return self.send strong_params
        end

        strong_params.call(params)
      end

      ##
      # This is a helper method to get the object collection path.
      def collection_path
        self.send "#{class_name.model_name.route_key}_path"
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
          respond_with *args, &block
        else
          options[:location] = block.call if block
          respond_with *args
        end
      end

      ##
      # This method set the flash messages if they are passed within the action
      # ==== Params
      # * options: a hash with :notice or :alert messages
      def set_flash(options = {})
        if options.has_key?(:notice)
          flash[:notice] = options[:notice]
        elsif options.has_key?(:alert)
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
          m.update_attributes secure_params
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
      # * model: A requires parameter which is a symbol of the model name.
      # * strong_params: A symbol, a string or a proc for the method that
      # should apply the strong parameters to allow Active Model mass
      # assignments.
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
      #     restful model: :document, strong_params: :document_params
      #   end
      #
      # This definition will create the seven REST actions for Document model,
      # this setup a single object instance variable @document and a collection
      # variable @documents.
      #
      # It's expected that this controller will provide a method
      # document_params which will be used to allow mass assignments.
      #
      # Strong params variation:
      #
      #   class DocumentsController < ApplicationController
      #     include Restful::Base
      #     respond_to :html
      #
      #     restful model: :document,
      #       strong_params: ->(params){ params.require(:document).permit :name  }
      #   end
      #
      # In this example instead of providing a strong params method by string
      # or symbol, a proc is passed to do the same job.
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
      #     restful model: :document, strong_params: :document_params,
      #       actions: [:index, :show]
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
      #     restful model: :document, strong_params: :document_params,
      #       actions: [:all, except: [:destroy, :show]]
      #   end
      #
      # For this last example all seven REST actions will be defined but
      # :destroy and :show
      #
      # ==== Considerations
      # From previous examples you must have notice by now that the respond_to
      # macro es need it. This is because all REST actions call the
      # respont_with method, which works with the respond_to macro. Just
      # include it in your controllers and list the formats do you wish your
      # controller to respond.
      #
      def restful(model: nil, strong_params: nil, actions: :all)
        self.class_attribute :model_name, :class_name, :strong_params,
          instance_writer: false

        self.model_name = model
        self.strong_params = strong_params
        self.class_name = class_from_name

        include InstanceMethods
        include Restful::Actions

        setup_actions actions unless actions == :all

        helper_method :collection, :resource
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
        except_actions = options[:except]
        keep_actions = keep_actions - except_actions

        (ACTIONS - keep_actions).uniq.each do |action|
          undef_method action.to_sym, "#{action.to_sym}!"
        end
      end

      ##
      # Method that gets the model class name from the passed symbol.
      def class_from_name
        if model_name.to_s.include? '_'
          ns, *klass = model_name.to_s.split('_').collect(&:camelize)
          begin
            "#{ns}::#{klass.join('')}".constantize
          rescue NameError
            "#{ns}#{klass.join('')}".constantize
          end
        else
          model_name.to_s.camelize.constantize
        end
      end
    end
  end
end
