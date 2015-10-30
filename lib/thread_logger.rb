require "thread_logger/version"

# require all
Dir[File.join(__dir__, 'thread_logger', '**', '*.rb')].each {|rb| require rb}

module ThreadLogger

  def self.binder_classes
    @binder_classes ||= ThreadLogger::Binders.constants.map{|c|
      const = ThreadLogger::Binders.const_get(c)
      if Class === const
        const
      end
    }.compact
  end

  def self.detect_binder_class(logger)
    binder_classes.detect{|binder| binder.bindable?(logger)}
  end

  # @return [Object] original logger instance
  def self.hijack(logger, options={})
    hijacker = ThreadLogger::Hijacker.new
    hijacker.hijack(logger, options)
    logger
  end

  def self.config
    @config ||= ThreadLogger::Configuration.new
  end
end
