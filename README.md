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
