module Graphiti
  if defined?(Graphiti::Rails)
    remove_const :Rails
  end

  module Rails
    def self.included(_klass)
      ActiveSupport::Deprecation.warn("With graphiti-rails, including Graphiti::Rails is unnecessary")
    end

    autoload :Context, "graphiti/rails/context"
    autoload :Debugging, "graphiti/rails/debugging"
    autoload :Errors, "graphiti/rails/errors"
    autoload :ExceptionsApp, "graphiti/rails/exceptions_app"
  end
end

require "graphiti/rails/railtie"

# The standard Rails ShowExceptions middleware handles exceptions and either
# displays them (in test and development, by default) or calls the exceptions_app
# to render in a user-friendly format. Unfortunately, the default exceptions_app
# does not handle Graphiti errors as specifically as we would prefer. To handle this,
# we wrap the default app and handle those errors ourselves.
ActionDispatch::ShowExceptions.class_eval do
  alias_method :initialize_without_graphiti, :initialize
  def initialize(*args)
    initialize_without_graphiti(*args)
    @exceptions_app = Graphiti::Rails::ExceptionsApp.new(@exceptions_app)
  end
end

ActiveSupport.on_load(:action_controller) do
  include Graphiti::Rails::Context
  include Graphiti::Rails::Errors
  include Graphiti::Rails::Debugging
end
