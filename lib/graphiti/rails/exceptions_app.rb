module Graphiti
  module Rails
    # This Rack app looks for content types that should be handled with a GraphitiErrors::ExceptionHanlder
    # and renders them accordingly. Other exceptions are passed on to the app specified in the Rails app's
    # `config.exceptions_app`.
    class ExceptionsApp
      def initialize(app)
        @app = app
      end

      def call(env)
        request = ActionDispatch::Request.new(env)
        content_type = request.formats.first rescue nil
        exception = request.get_header "action_dispatch.exception"

        if Graphiti::Rails.render_exception_for_format?(content_type)
          status, format, body = Graphiti::Rails.rendered_exception(exception, content_type: content_type)

          [status, { "Content-Type" => "#{format}; charset=#{ActionDispatch::Response.default_charset}",
            "Content-Length" => body.bytesize.to_s }, [body]]
        else
          @app.call(env)
        end
      end
    end
  end
end
