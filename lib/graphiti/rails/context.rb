module Graphiti
  module Rails
    module Context
      def self.included(klass)
        klass.class_eval do
          # QUESTION: Any downside to including this in all Rails controllers?
          include Graphiti::Context
          around_action :wrap_graphiti_context
        end
      end

      # QUESTION: Is it fine if we wrap even non-Graphiti actions?
      def wrap_graphiti_context
        Graphiti.with_context(jsonapi_context, action_name.to_sym) do
          yield
        end
      end

      def jsonapi_context
        self
      end
    end
  end
end
