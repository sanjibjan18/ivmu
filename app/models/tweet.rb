class Tweet < ActiveRecord::Base
  belongs_to :user
  belongs_to :movie


  def self.fetch_tweets(user)
    unless user.twitter_omniauth.blank?
      search = Twitter::Search.new
      screen_name = user.user_profile.twitter_screen_name
      Movie.all.each do |movie|
        unless movie.name.blank?
          if user.tweets_fetched_on.blank?
            search.containing("#{movie.name}").from("#{screen_name}").each do |tweet|
              user.tweets.create(:movie_id => movie.id, :content => tweet.text)
            end
          else
            search.containing("#{movie.name}").from("#{screen_name}").since_date("#{user.tweets_fetched_on}").each do |tweet|
              user.tweets.create(:movie_id => movie.id, :content => tweet.text)
            end
          end
          search.clear
        end
      end
      user.update_attribute("tweets_fetched_on", Date.today.to_s)
    end
  end

end

