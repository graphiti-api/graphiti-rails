module Graphiti
  module Rails
    class ExceptionHandler < RescueRegistry::ExceptionHandler
      # We've actually changed the signature here which is somewhat risky...
      def build_payload(show_details: false, traces: nil, style: :rails)
        case style
        when :standard
          super(show_details: show_details, traces: traces)
        when :rails
          # TODO: Find way to not duplicate RailsExceptionHandler
          body = {
            status: status_code,
            error:  title
          }

          if show_details
            body[:exception] = exception.inspect
            if traces
              body[:traces] = traces
            end
          end

          body
        else
          raise ArgumentError, "unknown style #{style}"
        end
      end

      def formatted_response(content_type, **options)
        # We're relying on the fact that `formatted_response` passes through unknown options to `build_payload`
        if Graphiti::Rails.handled_exception_formats.include?(content_type.to_sym)
          options[:style] = :standard
        end
        super
      end
    end

    class FallbackHandler < ExceptionHandler
      def formatted_response(content_type, **options)
        if Graphiti::Rails.handled_exception_formats.include?(content_type.to_sym)
          super
        else
          # The nil response will cause the default Rails handler to be used
          nil
        end
      end
    end

    class InvalidRequestHandler < ExceptionHandler
      # Mostly copied from GraphitiErrors could use some cleanup
      # NOTE: That `style` is ignored
      def build_payload(show_details: false, traces: nil, style: nil)
        errors = exception.errors

        errors_payload = []
        errors.details.each_pair do |attribute, att_errors|
          att_errors.each_with_index do |error, idx|
            code = error[:error]
            message = errors.messages[attribute][idx]

            errors_payload << {
              code: "bad_request",
              status: "400",
              title: "Request Error",
              detail: errors.full_message(attribute, message),
              source: {
                pointer: attribute.to_s.tr(".", "/").gsub(/\[(\d+)\]/, '/\1'),
              },
              meta: {
                attribute: attribute,
                message: message,
                code: code,
              },
            }
          end
        end

        { errors: errors_payload }
      end
    end
  end
end

