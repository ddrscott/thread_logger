module ThreadLogger
  module HistoryMixin

    THREAD_VAR = '__history_instance'

    def history=(history_instance)
      Thread.current[THREAD_VAR] = history_instance
    end

    def history
      Thread.current[THREAD_VAR]
    end
  end
end