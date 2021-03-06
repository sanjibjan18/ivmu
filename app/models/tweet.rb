class Tweet < ActiveRecord::Base
  belongs_to :user
  belongs_to :movie

  scope :latest, order('tweeted_on desc nulls last')
  scope :reviews, where(:interest => false)
  scope :interests, where(:interest => true)
  scope :pos_or_neg, where("review = ? or review = ? ", 'pos', 'neg')
  scope :neu_or_ign, where("review = ? or review = ? ", 'neu', 'ign')

  def self.fetch_tweets
    last_tweet = Tweet.last
    search = Twitter::Search.new
    Movie.name_without_dictionary_word.name_is_not_blank.latest.limit(6).each do |movie|
      if last_tweet.blank?
        Tweet.tweet_pagination(search.containing("#{movie.name}").per_page(100), movie)
      else
        Tweet.tweet_pagination(search.containing("#{movie.name}").since_date("#{last_tweet.created_at.to_date.to_s}").per_page(100), movie)
      end
      search.clear
    end # all movies end
  end # def end

  def self.fetch_tweets_for_all_movies
    last_tweet = Tweet.last
    search = Twitter::Search.new
    Movie.name_without_dictionary_word.name_is_not_blank.latest.each do |movie|
      if last_tweet.blank?
        Tweet.tweet_pagination(search.containing("#{movie.name}").per_page(100), movie)
      else
        Tweet.tweet_pagination(search.containing("#{movie.name}").since_date("#{last_tweet.created_at.to_date.to_s}").per_page(100), movie)
      end
      search.clear
    end # all movies end
  end # def end


  def self.tweet_pagination(search, movie)
    search.each do |tweet|
      Tweet.create_tweet(tweet, movie)
    end
  #  if search.next_page? # only 100 tweet created so this one commented
   #   search.fetch_next_page
    #  Tweet.tweet_pagination(search, movie)
  #  else
    #  search.fetch_next_page
    #  search.each do |tweet|
    #    Tweet.create_tweet(tweet, movie)
    #  end
   # end
  end


  def self.create_tweet(tweet, movie)
    movie_tweet = { :content => tweet.text, :twitter_id => tweet.from_user_id, :tweeted_on => tweet.created_at, :twitter_screen_name => tweet.from_user, :tweet_id => tweet.id.to_s }
    user_profile = UserProfile.find_by_twitter_screen_name(tweet.from_user)
    if user_profile
      movie_tweet[:user_id] = user_profile.user_id
    end

    if (!movie.release_date.blank? && tweet.created_at.to_date < movie.release_date.to_date)
      movie_tweet[:interest] = true
    end
    unless movie.tweets.collect(&:tweet_id).include?(tweet.id.to_s)
      tw = movie.tweets.create(movie_tweet)
      Activity.log_activity(tw, movie, 'twitted', user_profile.user_id) if user_profile
    end
  end

  def self.fetch_tweet_for_movie(movie)
     search = Twitter::Search.new
     last_tweet = movie.tweets.last rescue nil
     if last_tweet.blank?
       Tweet.tweet_pagination(search.containing("#{movie.name}").per_page(100), movie)
     else
       Tweet.tweet_pagination(search.containing("#{movie.name}").since_date("#{last_tweet.created_at.to_date.to_s}").per_page(100), movie)
     end
     search.clear
  end

  def self.delete_neu_or_ign_tweets
    Tweet.neu_or_ign.each do |tweet|
      TweetIgnNeu.create(tweet.attributes.except("id", "updated_at", "created_at"))
      tweet.destroy
    end
  end



end

