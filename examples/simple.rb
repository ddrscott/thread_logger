module Main
  class Application < Rails::Application

    ThreadLogger.config.max_entries = 100

    # hijack a logger that's already configured
    config.logger = ThreadLogger.hijack(config.logger)

  end

  class ApplicationController < ActionController::Base

    before_filter do
      logger.history.clear
    end

    rescue_from Exception do |exception|
      send_error exception
      raise exception
    end

    def send_error(exception)
      logger.error(exception)
      Mailman.support(exception, log: logger.history).deliver
    end
  end
end

