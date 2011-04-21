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
every 1.day do
   runner "Tweet.fetch_tweets"
   runner "Movie.update_top_box_office"
   runner "Movie.update_top_trending"
   runner "Movie.update_tweets_count"
end


every 2.hours do
  runner "Movie.update_reviews_precentage"
end


# Learn more: http://github.com/javan/whenever

