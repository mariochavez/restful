class BaseController < ApplicationController
  include Resourceful::Base

  respond_to :html
end
