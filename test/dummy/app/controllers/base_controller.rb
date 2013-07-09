class BaseController < ApplicationController
  include Restful::Base

  respond_to :html
end
