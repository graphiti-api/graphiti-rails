# The standard Rails ShowExceptions middleware passes exceptions on to `config.exceptions_app`.
# Here we wrap the specified exceptions app to handle desired content types via GraphititErrors::ExceptionHandler.
# See {file:README.md#actiondispatchshowexceptions} for more details.
class ActionDispatch::ShowExceptions
  # TODO: See about adding a Rails API for this

  # @private
  alias_method :initialize_without_graphiti, :initialize

  # @private
  def initialize(*args)
    initialize_without_graphiti(*args)
    @exceptions_app = Graphiti::Rails::ExceptionsApp.new(@exceptions_app)
  end
end

# Here we monkeypatch to support using GraphitiErrors::ExceptionHandler where desired.
# See {file:README.md#actiondispatchdebugexceptions} for more details.
#
# Set `config.debug_exception_response_format = :api` for this to work correctly.
#
# NOTE: There may be some benefit in not changing `debug_exception_response_format` since
# an HTML formatted error might render more nicely in browser developer tools than JSON formatted.
class ActionDispatch::DebugExceptions
  private

  # TODO: Investigate adding a Rails hook for this.
  alias_method :render_for_api_request_without_graphiti, :render_for_api_request
  def render_for_api_request(content_type, wrapper)
    if Graphiti::Rails.render_exception_for_format?(content_type)
      status, format, body = Graphiti::Rails.rendered_exception(wrapper.exception, content_type: content_type, show_raw_error: true)
      render(status, body, format)
    else
      render_for_api_request_without_graphiti(content_type, wrapper)
    end
  end
end
