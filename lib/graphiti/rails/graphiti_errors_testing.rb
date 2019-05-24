module Graphiti
  module Rails
    module GraphitiErrorsTesting
      include RescueRegistry::RailsTestHelpers

      def enable!
        DEPRECATOR.deprecation_warning("GraphitiError.enable! in tests", "This method may cause leaked behavior between tests! Wrap in Graphiti::Rails::TestHelpers#handle_request_exceptions instead.")
        super
        handle_request_exceptions(true)
      end

      def disable!
        DEPRECATOR.deprecation_warning("GraphitiError.disable! in tests", "This method may cause leaked behavior between tests! Wrap in Graphiti::Rails::TestHelpers#handle_request_exceptions instead. Note that exceptions are no longer caught by default during testing.")
        handle_request_exceptions(false)
      ensure
        super
      end
    end
  end
end
