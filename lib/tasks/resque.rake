require 'resque/tasks'
require 'resque_scheduler/tasks'

namespace :resque do
  # todo dont require the whole environment
  task :setup => :environment do
    require 'resque'
    require 'resque_scheduler'
    require 'resque/scheduler'

    # Resque.redis = 'localhost:6379'

    # # just needs to be a Hash
    # Resque.schedule = YAML.load_file('your_resque_schedule.yml')

    # require 'jobs'
  end
end
