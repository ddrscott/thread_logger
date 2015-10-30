require "thread_logger/version"

module ThreadLogger

  class Hijacker

    def hijack(logger, options={})

      binder = ThreadLogger.detect_binder_class(logger)

      if binder

        instance = binder.new

        logger.extend(ThreadLogger::HistoryMixin)

        instance.pipe_appender(logger, options)

        logger
      else
        logger.warn("Could not hijack #{logger}. Could not figure out its type. Are you sure it's really a logger instance?")
      end

      logger
    end
  end

end
