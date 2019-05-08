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

        if Graphiti::Rails.render_exception_for_format?(content_type)
          status, payload = Graphiti::Rails.exception_details(exception)
          body = payload.to_json

          # TODO: Do we need to log here?

          [status, { "Content-Type" => "#{content_type}; charset=#{ActionDispatch::Response.default_charset}",
            "Content-Length" => body.bytesize.to_s }, [body]]
        else
          @app.call(env)
        end
      end
    end
  end
end
