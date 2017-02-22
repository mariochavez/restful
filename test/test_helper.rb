# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require File.expand_path('../dummy/config/environment.rb',  __FILE__)
require 'rails/test_help'
require 'minitest/rails'

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Load fixtures from the engine
if ActiveSupport::TestCase.method_defined?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path =
    File.expand_path('../fixtures', __FILE__)
end

##
# Base class for Tests
class ActiveSupport::TestCase
  migrations_path = File.expand_path('../dummy/db/migrate', __FILE__)
  ActiveRecord::Migrator.migrate migrations_path

  fixtures :all

  class << self
    alias_method :context, :describe
  end
end
