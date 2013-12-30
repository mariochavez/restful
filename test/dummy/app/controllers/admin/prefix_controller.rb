class Admin::PrefixController < BaseController

  restful model: :document, route_prefix: 'admin'
end
