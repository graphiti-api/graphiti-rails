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

# The standard Rails ShowExceptions middleware passes exceptions on to `config.exceptions_app`.
# However, the default exceptions_app (PublicExceptions) doesn't handle JSON API responses
# correctly, so we wrap it ourselves to ensure correct handling.
#
# One potential problem here is if people want to handle the JSON API responses themselves.
# In that case, we might actually want to extend PublicExceptions insteand and then let people use
# their own handling when they overwite the exceptions app. The downside to this is that people
# setting their own exceptions app may not know that they should handle JSON API specially.
#
# If we continue with this approach, we should see about getting an API into Rails for this.
ActionDispatch::ShowExceptions.class_eval do
  alias_method :initialize_without_graphiti, :initialize
  def initialize(*args)
    initialize_without_graphiti(*args)
    @exceptions_app = Graphiti::Rails::ExceptionsApp.new(@exceptions_app)
  end
end

# Since we have more information for JSON API errors from Graphiti we hijack the defaults
# and do do the better rendering. Ideally, we'd have a hook in Rails for this.
#
# Set `config.debug_exception_response_format = :api` for this to work correctly.
#
# TODO: Investigate whether dev tools will render a returned HTML formatted error correctly.
# If so, there may be some benefit in not changing `debug_exception_response_format` since
# an HTML formatted error might be nicer to read than JSON formatted. However, we should
# still handle the JSON API case correctly when `debug_exception_response_format == :api`.
ActionDispatch::DebugExceptions.class_eval do
  private

  alias_method :render_for_api_request_without_graphiti, :render_for_api_request
  def render_for_api_request(content_type, wrapper)
    return super unless content_type == :jsonapi

    # TODO: Make this configurable, also handle invalid requests correctly
    handler = Graphiti::Rails::ExceptionHandler.new
    handler.show_raw_error = true

    json   = exception_klass.error_payload(e)
    status = exception_klass.status_code(e)

    render(status, json.to_json, content_type)
  end
end

ActiveSupport.on_load(:action_controller) do
  include Graphiti::Rails::Context
  include Graphiti::Rails::Errors
  include Graphiti::Rails::Debugging
end
