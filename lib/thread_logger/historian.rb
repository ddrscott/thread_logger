module ThreadLogger
  class Historian
    include Enumerable

    attr_reader :logs

    def initialize
      if config.max_entries
        @logs = RingBuffer.new(config.max_entries)
      else
        @logs = []
      end
    end

    def config
      ThreadLogger.config
    end

    def add(text)
      @logs << text
    end

    alias <<   add
    alias push add

    # pass everything else to @logs
    def method_missing(meth_name, *args, &block)
      @logs.__send__(meth_name, *args, &block)
    end
  end
end