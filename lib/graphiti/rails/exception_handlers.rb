module Graphiti
  module Rails
    # Extends the default GraphitiErrors::ExceptionHandler for more Railsy behavior.
    module ExceptionHandlerExtensions
      # Returns the status code for the given error.
      # Unlike the default behavior, it will look for codes {Railtie registered with ActionDispatch}
      # before defaulting to 500.
      # @return [Integer] HTTP Status Code
      def status_code(error)
        # TODO: See if we can get GraphitiErrors to have default codes
        @status || ActionDispatch::ExceptionWrapper.status_code_for_exception(error.class.name) || 500
      end

      # Returns a detailed error message.
      # Unlike the default behavior in that it does not send a fallback detail if the error is not fatal.
      # @return [String]
      def detail(error)
        if @message == true
          error.message
        else
          @message ? @message.call(error) : default_detail(error)
        end
      end

      # Whether the error is fatal, i.e. 5xx
      # @return [Boolean]
      def fatal?(error)
        # TODO: Get some notion of fatal errors into GraphitiErrors
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

      # Returns a title for the error.
      # Unlike the default behavior, it tries to get a name from Rack::Util's list of status code mappings
      # before falling back to the default "Error".
      # @return [String]
      def title(error = nil)
        # TODO: Have GraphitiErrors take the parameter by default
        @title || Rack::Utils::HTTP_STATUS_CODES[status_code(error)] || "Error"
      end

      # Returns the payload for the error
      # Augments the default behavior with smarter titles.
      # @return [Hash]
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
