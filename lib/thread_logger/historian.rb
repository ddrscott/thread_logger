require 'bcat/ansi'

module ThreadLogger
  class Historian
    attr_reader :logs

    def initialize(max_entries=ThreadLogger.config.max_entries)
      if max_entries
        @logs = RingBuffer.new(max_entries)
      else
        @logs = []
      end
    end

    def add(text)
      @logs << text
    end

    alias <<   add
    alias push add

    # pass everything else to @logs
    def method_missing(meth_name, *args, &block)
      @logs.public_send(meth_name, *args, &block)
    end

    def respond_to_missing?(*args)
      @logs.respond_to?(*args)
    end

    def to_text
      @logs.join
    end

    def to_html
      Bcat::ANSI.new(to_text).to_html
    end

    def to_s
      "[size: #{size}] #{last}"
    end

  end
end