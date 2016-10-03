require 'semantic_logger'
require 'thread_logger/history_mixin'

module ThreadLogger
  module Binders
    # Binds a history to a SemanticLogger
    class SemanticBinder
      def self.bindable?(logger)
        logger.is_a?(SemanticLogger::Logger)
      end

      module LogHistoryCapturer
        include ThreadLogger::HistoryMixin
        def log(log, message = nil, progname = nil, &block)
          history << __formatter.call(log, self)
          super
        end

        def __formatter
          @formatter ||= SemanticLogger::Formatters::Default.new
        end
      end

      # We will add a HistoryAppender to SemanticLogger if it's not
      # already there.  The downside to this is that it's leaky, as
      # soon as this is done, every thread is going to have a thread
      # thread local history created for all of it's logging.
      def pipe_appender(history_logger, _options = {})
        unless SemanticLogger::Logger.ancestors.include?(LogHistoryCapturer)
          SemanticLogger::Logger.prepend(LogHistoryCapturer)
        end
        history_logger
      end
    end
  end
end
