# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

env :PATH, '/Users/highsoul/.rbenv/shims:/Users/highsoul/.rbenv/bin:/usr/local/bin:/usr/bin:/bin'
env :GEM_HOME, '/Users/highsoul/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0'
env :GEM_PATH, '/Users/highsoul/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0'

job_type :rbenv_rake, <<~CMD
  export PATH="/Users/highsoul/.rbenv/shims:/Users/highsoul/.rbenv/bin:$PATH";
  eval "$(rbenv init -)";
  cd :path && bundle exec rake :task --silent :output
CMD

set :output, "./log/cron_log.log"

every 1.hour do
  command "/Users/highsoul/dataX/backend/run_task.sh"
end