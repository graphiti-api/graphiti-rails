require 'graphiti/errors'

module Graphiti
  if defined?(Graphiti::Rails)
    remove_const :Rails
  end

  # Rails integration for Graphiti. See {file:README.md} for more details.
  module Rails
    # While this allow custom errors to be registered we currently don't recommend relying on this
    # functionality unless you are absolutely certain you know what you're doing. The main issue is
    # that not all error handling will go through the registered handlers by default.
    include GraphitiErrors

    def self.included(_klass)
      ActiveSupport::Deprecation.warn("With graphiti-rails, including Graphiti::Rails is unnecessary")
    end

    # A list of formats as symbols which will be handled by a GraphitiErrors::ExceptionHandler.
    # Defaults to `[:jsonapi]`.
    cattr_accessor :handled_exception_formats, default: []

    autoload :Context, "graphiti/rails/context"
    autoload :Debugging, "graphiti/rails/debugging"
    autoload :ExceptionsApp, "graphiti/rails/exceptions_app"
    autoload :DefaultExceptionHandler, "graphiti/rails/exception_handlers"
    autoload :InvalidRequestExceptionHandler, "graphiti/rails/exception_handlers"

    # The default exception handler for Graphiti::Rails errors.
    # In general, you should not need to call or modify this.
    # @private
    def self.default_exception_handler
      DefaultExceptionHandler
    end

    if defined?(Graphiti::Errors::InvalidRequest)
      register_exception Graphiti::Errors::InvalidRequest,
        handler: InvalidRequestExceptionHandler
    end

    # Returns a boolean of whether the specified content type should be handled by a Graphiti exception handler.
    # The list of format can be found in `.handled_exception_formats`.
    # @param content_type [Mime::Type]
    # @return [Boolean]
    def self.render_exception_for_format?(content_type)
      handled_exception_formats.include?(content_type.to_sym)
    end

    # @return [GraphitiErrors::ExceptionHandler]
    def self.exception_handler_for(exception)
      # TODO: Move this into GraphitiErrors
      _errorable_registry[exception.class] || default_exception_handler.new
    end

    # @param [Exception] exception
    # @param [Boolean] show_raw_error (false)
    # @return [Array<Integer, Hash>] HTTP status and payload
    def self.exception_details(exception, show_raw_error: false)
      # TODO: Move this into GraphitiErrors
      exception_klass = exception_handler_for(exception)
      exception_klass.show_raw_error = show_raw_error
      status = exception_klass.status_code(exception)
      payload = exception_klass.error_payload(exception)
      [status, payload]
    end

    # @param [Exception] exception
    # @param [Mime::Type] content_type
    # @param [Hash] keywords passed through to {.exception_details}
    # @return [Array<Integer, Mime::Type, String>] HTTP status, content type, and payload
    def self.rendered_exception(exception, content_type:, **keywords)
      status, body = exception_details(exception, **keywords)

      to_format = (content_type == :jsonapi) ? "to_json" : "to_#{content_type.to_sym}"

      if content_type && body.respond_to?(to_format)
        formatted_body = body.public_send(to_format)
        format = content_type
      else
        formatted_body = body.to_json
        format = Mime[:json]
      end

      [status, format, formatted_body]
    end
  end
end

ActiveSupport.on_load(:action_controller) do
  include Graphiti::Rails::Context
  include Graphiti::Rails::Debugging
end

require "graphiti/rails/railtie"
require 'graphiti/rails/action_dispatch'
