module Graphiti
  module Rails
    module ExceptionHandlerExtensions
      # Since we're registering the errors with ActionDispatch, we can also use that
      # for getting the status code.
      def status_code(error)
        @status || ActionDispatch::ExceptionWrapper.status_code_for_exception(error.class.name) || 500
      end

      def detail(error)
        if @message == true
          error.message
        else
          @message ? @message.call(error) : default_detail(error)
        end
      end

      def fatal?(error)
        status_code(error) >= 500
      end

      private

      def default_detail(error)
        if fatal?(error)
          "We've notified our engineers and hope to address this issue shortly."
        end
      end
    end

    class DefaultExceptionHandler < GraphitiErrors::ExceptionHandler
      include ExceptionHandlerExtensions

      # TODO: Have GraphitiErrors take the parameter by default
      def title(error = nil)
        @title || Rack::Utils::HTTP_STATUS_CODES[status_code(error)] || "Error"
      end

      def error_payload(error)
        super.tap do |payload|
          payload[:errors][0][:title] = title(error)
        end
      end
    end

    class InvalidRequestExceptionHandler < GraphitiErrors::InvalidRequest::ExceptionHandler
      include ExceptionHandlerExtensions
    end
  end
end
