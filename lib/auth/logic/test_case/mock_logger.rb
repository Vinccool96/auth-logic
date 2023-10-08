# frozen_string_literal: true

module Authentication
  module Logic
    module TestCase
      # Simple class to replace real loggers, so that we can raise any errors being logged.
      class MockLogger
        def error(message)
          raise message
        end
      end
    end
  end
end
