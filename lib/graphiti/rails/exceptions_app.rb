module Graphiti
  module Rails
    # Similar function to GraphitiErrors#handle_exceptions but more Railsy
    #
    # This Rack app looks for JSON API requests then renders them in a more correct format.
    # Other exceptions are passed on to the app specified in the Rails app's `config.exceptions_app`.
    class ExceptionsApp
      def initialize(app)
        @app = app
      end

      def call(env)
        request = ActionDispatch::Request.new(env)
        content_type = request.formats.first rescue nil
        exception = request.get_header "action_dispatch.exception"
        context = request.get_header "graphiti.error_lookup_context"

        # Ensure all JSON API responses are in the correct format
        if content_type == :jsonapi
          exception_klass = context&.graphiti_exception_handler_for(exception) || GraphitiErrors::ExceptionHandler.new

          # TODO: Do we actually want to log?
          exception_klass.log(exception)

          payload = exception_klass.error_payload(exception)
          status = exception_klass.status_code(exception)
          body = payload.to_json

          [status, { "Content-Type" => "#{content_type}; charset=#{ActionDispatch::Response.default_charset}",
            "Content-Length" => body.bytesize.to_s }, [body]]
        else
          @app.call(env)
        end
      end
    end
  end
end
