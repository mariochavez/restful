# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require File.expand_path('../dummy/config/environment.rb',  __FILE__)
require 'rails/test_help'
require 'minitest/rails'

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

##
# Minitest module to redefine expectations, use it to
# fine tune your modules
module MiniTest::Expectations
  infect_an_assertion :assert_redirected_to, :must_redirect_to
  infect_an_assertion :assert_template, :must_render_template
  infect_an_assertion :assert_response, :must_respond_with
end

# Load fixtures from the engine
if ActiveSupport::TestCase.method_defined?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path =
    File.expand_path('../fixtures', __FILE__)
end

##
# Base class for Tests
class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  fixtures :all

  class << self
    alias_method :context, :describe
  end
end
