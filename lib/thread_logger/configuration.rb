module ThreadLogger
  class Configuration

    DEFAULT_MAX_ENTRIES = 1000

    attr_accessor :max_entries

    def initialize
      self.max_entries = DEFAULT_MAX_ENTRIES
    end

  end
end
