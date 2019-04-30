module Graphiti
  module Rails
    module Debugging
      def self.included(klass)
        # QUESTION: Do we always want this enabled, even in production?
        klass.around_action :debug_graphiti
      end

      # QUESTION: Is it fine if we wrap even non-Graphiti actions?
      def debug_graphiti
        Debugger.debug do
          yield
        end
      end
    end
  end
end
