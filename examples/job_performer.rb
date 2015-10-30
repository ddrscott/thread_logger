require 'logger'

# config max
ThreadLogger.config.max_entries = 100

# setup logger
$logger = ThreadLogger.hijack Logger.new($stdout)

class JobPerformer
  include Sidekiq::Worker

  def perform
    $logger.info('starting job')
    0 / 0  # ZeroDivisionError
    $logger.info('finished job')
  rescue
    $logger.error("oops! #{$!} #{$!.backtrace}")
    write_to_file($logger.history.to_text)
  end

  def write_to_file(text)
    # ...
  end
end
