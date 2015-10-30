module RailsApp
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

      # convert history to text
      Mailman.support(exception, log: logger.history.to_text).deliver

      # convert history to HTML
      Mailman.support(exception, html: logger.history.to_html).deliver
    end
  end
end

