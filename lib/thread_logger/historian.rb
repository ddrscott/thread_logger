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

    # delegate to log
    def each(&block)
      @logs.each(&block)
    end

  end
end