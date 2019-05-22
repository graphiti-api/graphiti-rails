module Graphiti
  module Rails
    module GraphitiErrorsTesting
      include RescueRegistry::RailsTestHelpers

      def enable!
        DEPRECATOR.deprecation_warning("GraphitiError.enable! in tests", "Use RescueRegistry::RailsTestHelpers#handle_request_exceptions instead.")

        super

        if @original_show_exceptions.nil?
          @original_show_exceptions = handle_request_exceptions?
        end

        handle_request_exceptions(true)
      end

      def disable!
        DEPRECATOR.deprecation_warning("GraphitiError.disable! in tests", "Use RescueRegistry::RailsTestHelpers#handle_request_exceptions(false), instead. Note that exceptions are no longer caught by default during testing.")

        unless @original_show_exceptions.nil?
          handle_request_exceptions(@original_show_exceptions)
          @original_show_exceptions = nil
        end
      ensure
        super
      end
    end
  end
end
