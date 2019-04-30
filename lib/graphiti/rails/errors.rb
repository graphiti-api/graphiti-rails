module Graphiti
  module Rails
    # Based on the GraphitiErrors module but simplified and with more unique method names
    module Errors
      def self.included(klass)
        klass.class_eval do
          class << self
            attr_accessor :_errorable_graphiti_registry
          end
          self._errorable_graphiti_registry = {}
        end

        # TODO: Review whether we should include this
        # klass.send(:include, GraphitiErrors::Validatable)

        klass.extend ClassMethods

        klass.before_action do
          request.set_header("graphiti.error_lookup_context", self.class)
        end
      end

      module ClassMethods
        def inherited(subklass)
          super
          subklass._errorable_graphiti_registry = _errorable_graphiti_registry.dup
        end

        def register_graphiti_exception(klass, options = {})
          exception_klass = options[:handler] || default_graphiti_exception_handler
          _errorable_graphiti_registry[klass] = exception_klass.new(options)
        end

        def default_graphiti_exception_handler
          GraphitiErrors::ExceptionHandler
        end

        def registered_graphiti_exception?(exception)
          _errorable_graphiti_registry.key?(exception.class)
        end

        def graphiti_exception_handler_for(exception)
          _errorable_graphiti_registry[exception.class] || default_graphiti_exception_handler.new
        end
      end
    end
  end
end
