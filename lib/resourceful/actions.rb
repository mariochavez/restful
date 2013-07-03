module Resourceful
  module Actions
    def index(options = {}, &block)
      respond_with(collection, options,  &block)
    end

    def new(options = {}, &block)
      respond_with(build_resource, options, &block)
    end

    def create(options = {}, &block)
      object = get_resource_ivar || create_resource

      if object.errors.empty?
        options[:location] = collection_path
      end

      respond_with_dual(object, options, &block)
    end

    def edit(options = {}, &block)
      object = get_resource_ivar || find_resource

      respond_with(object, options, &block)
    end

    def update(options = {}, &block)
      object = get_resource_ivar || find_and_update_resource

      if object.errors.empty?
        options[:location] = collection_path
      end

      respond_with_dual(object, options, &block)
    end

    def show(options = {}, &block)
      object = get_resource_ivar || find_resource

      respond_with(object, options, &block)
    end

    def destroy(options = {}, &block)
      object = get_resource_ivar || find_resource

      object.destroy
      options[:location] = collection_path

      respond_with(object, options, &block)
    end

  end
end
