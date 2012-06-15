require 'resque/tasks'

# todo dont require the whole environment
task 'resque:setup' => :environment
