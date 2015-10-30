module ThreadLogger
  module Binders
    class Log4rBinder
      def self.bindable?(logger)
        logger.respond_to?(:outputters) and logger.outputters.is_a? Array
      end

      # Nothing to do.
      # Logger should setup a HistorianOutputter
      def pipe_appender(history_logger, options)

        outputter = options[:outputter] || raise(':outputter is not found in options!')

        found = history_logger.outputters.detect{|d| d == outputter}

        unless found
          raise "#{outputter} in options not found in logger's list of outputters: #{history_logger.outputters.inpsect}"
        end

        add_historian_outputter(history_logger, outputter.formatter)

        history_logger
      end

      def add_historian_outputter(history_logger, formatter)
        null_file = File.open(File::NULL, 'a')
        log4r_outputter = Log4r::IOOutputter.new('historian', null_file)
        log4r_outputter.formatter = formatter

        log4r_outputter.extend(ThreadLogger::HistoryMixin)

        class << log4r_outputter
          def write(data)
            history << data
          end
        end

        history_logger.add(log4r_outputter)
        log4r_outputter
      end
    end
  end
end