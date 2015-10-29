require 'logger'

module ThreadLogger
  module Binders
    class StdLogger
      def self.bindable?(logger)
        logger.is_a?(::Logger)
      end

      def pipe_appender(history_logger)

        class << history_logger
          alias_method :orig_format_message, :format_message
          def format_message(*args)
            line = orig_format_message(*args)

            history << line

            line
          end
        end

        history_logger
      end
    end
  end
end