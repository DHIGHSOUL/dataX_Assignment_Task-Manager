#!/bin/bash
export HOME="/Users/highsoul"
export PATH="/Users/highsoul/.rbenv/bin:/Users/highsoul/.rbenv/shims:$PATH"
export GEM_HOME="/Users/highsoul/.rbenv/versions/3.2.2/lib/ruby/gems/3.2.0"
export GEM_PATH="$GEM_HOME"
eval "$(rbenv init -)"
cd /Users/highsoul/dataX/backend || exit 1

echo "[cron] $(date)" >> ./log/cron_log.log
echo "BUNDLE_EXEC: $(which bundle)" >> ./log/cron_log.log
echo "ruby: $(ruby -v)" >> ./log/cron_log.log
echo "bundle: $(bundle -v)" >> ./log/cron_log.log

bundle exec rake user_task_progresses:update --silent >> ./log/cron_log.log 2>&1