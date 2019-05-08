require 'graphiti/errors'

module Graphiti
  if defined?(Graphiti::Rails)
    remove_const :Rails
  end

  module Rails
    # While this allow custom errors to be registered we currently don't recommend relying on this
    # functionality unless you are absolutely certain you know what you're doing. The main issue is
    # that not all error handling will go through the registered handlers by default.
    include GraphitiErrors

    def self.included(_klass)
      ActiveSupport::Deprecation.warn("With graphiti-rails, including Graphiti::Rails is unnecessary")
    end

    cattr_accessor :handled_exception_formats, default: []

    autoload :Context, "graphiti/rails/context"
    autoload :Debugging, "graphiti/rails/debugging"
    autoload :ExceptionsApp, "graphiti/rails/exceptions_app"
    autoload :DefaultExceptionHandler, "graphiti/rails/exception_handlers"
    autoload :InvalidRequestExceptionHandler, "graphiti/rails/exception_handlers"

    def self.default_exception_handler
      DefaultExceptionHandler
    end

    if defined?(Graphiti::Errors::InvalidRequest)
      register_exception Graphiti::Errors::InvalidRequest,
        handler: InvalidRequestExceptionHandler
    end

    def self.render_exception_for_format?(content_type)
      handled_exception_formats.include?(content_type.to_sym)
    end

    # TODO: Move this into GraphitiErrors
    def self.exception_handler_for(exception)
      _errorable_registry[exception.class] || default_exception_handler.new
    end

    # TODO: Move this into GraphitiErrors
    def self.exception_details(exception, show_raw_error: false)
      exception_klass = exception_handler_for(exception)
      exception_klass.show_raw_error = show_raw_error
      status = exception_klass.status_code(exception)
      payload = exception_klass.error_payload(exception)
      [status, payload]
    end
  end
end

ActiveSupport.on_load(:action_controller) do
  include Graphiti::Rails::Context
  include Graphiti::Rails::Debugging
end

require "graphiti/rails/railtie"
require 'graphiti/rails/action_dispatch'
