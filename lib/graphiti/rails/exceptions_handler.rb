module Graphiti
  module Rails
    class ExceptionHandler < GraphitiErrors::ExceptionHandler
      # Since we're registering the errors with ActionDispatch, we can also use that
      # for getting the status code.
      def status_code(error)
        ActionDispatch.ExceptionWrapper.status_code_for_exception(error.class.name)
      end

      def detail(error)
        if status_code(error) >= 500
          default_detail
        end
      end
    end
  end
end
