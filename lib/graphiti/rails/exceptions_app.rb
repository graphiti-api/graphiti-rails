module Graphiti
  module Rails
    # Similar function to GraphitiErrors#handle_exceptions but more Railsy
    #
    # This Rack app looks for Graphiti exceptions and, if registered, will render them in
    # in a nicer format. Also, if the request is JSON API then we clean it up for more uniform display.
    # Other exceptions are passed on to the app specified in the Rails app's `config.exceptions_app`.
    class ExceptionsApp
      def initialize(app)
        @app = app
      end

      def call(env)
        request = ActionDispatch::Request.new(env)

        begin
          content_type = request.formats.first
        rescue Mime::Type::InvalidMimeType
          content_type = Mime[:text]
        end

        exception = request.get_header "action_dispatch.exception"
        context = request.get_header "graphiti.error_lookup_context"

        # Render handled exceptions, also ensure all JSONAPI responses are in a machine readable format
        if context && (context.registered_graphiti_exception?(exception) || content_type == :jsonapi)
          exception_klass = context.graphiti_exception_handler_for(exception)
          exception_klass.log(exception)

          payload = exception_klass.error_payload(exception)
          status = exception_klass.status_code(exception)
          body = payload.to_json

          [status, { "Content-Type" => "application/json; charset=#{ActionDispatch::Response.default_charset}",
            "Content-Length" => body.bytesize.to_s }, [body]]
        else
          @app.call(env)
        end
      end
    end
  end
end
