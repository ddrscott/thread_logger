# Overview
This is a logger wrapper that keeps in memory a ring buffer of log lines
isolated to the `Thread.current`.
The main use of this is to have access to log history for when exception
happen.

## Example Use

```ruby
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

      # convert history to text
      Mailman.support(exception, log: logger.history.to_text).deliver

      # convert history to HTML
      Mailman.support(exception, html: logger.history.to_html).deliver
    end
  end
end
```

look in /examples directory for more examples 

# Features

## As a Developer
[x] use public_send instead of __send__
[x] general log capture with thread friendly ring buffer
[ ] clear history based on matchers
[ ] limit RingBuffer based on memory consumption
[x] default max entries so we don't run out of memory for anyone that forgets
[x] convert log to HTML


# Use with standard Ruby Logger

```
# Set how many entries to keep
ThreadLogger.config.max_entries = 5

# Hijack the standard logger instance
logger = ThreadLogger.hijack(Logger.new($stdout))

# Do some logging
('a'..'z').each{|l| logger.info l}
=> 
I, [2015-10-29T14:56:59.242216 #35557]  INFO -- : a
I, [2015-10-29T14:56:59.242265 #35557]  INFO -- : b
...
I, [2015-10-29T14:56:59.242608 #35557]  INFO -- : z

# Get the history
logger.history.to_a
=> 
["I, [2015-10-29T14:57:51.297326 #36535]  INFO -- : v\n",
 "I, [2015-10-29T14:57:51.297338 #36535]  INFO -- : w\n",
 "I, [2015-10-29T14:57:51.297349 #36535]  INFO -- : x\n",
 "I, [2015-10-29T14:57:51.297361 #36535]  INFO -- : y\n",
 "I, [2015-10-29T14:57:51.297373 #36535]  INFO -- : z\n"]
```


# Use with Log4r
```
# Set how many entries to keep
ThreadLogger.config.max_entries = 5

require 'log4r'

logger = Log4r::Logger.new 'mylog'
outputter = Log4r::Outputter.stdout
logger.outputters = outputter

logger = ThreadLogger.hijack(logger, outputter: outputter)

# do some logging
('a'..'z').each{|l| logger.info l}
 INFO mylog: a
 INFO mylog: b
 INFO mylog: c
 ...
 INFO mylog: z
 
# get the history
logger.history.to_a
=> [" INFO mylog: v\n",
 " INFO mylog: w\n",
 " INFO mylog: x\n",
 " INFO mylog: y\n",
 " INFO mylog: z\n"]
```
