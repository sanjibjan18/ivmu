class UpdateCounterCache < ActiveRecord::Migration
  def self.connection
    Movie.connection
  end
  def self.up
    Movie.reset_column_information
    Movie.all.each do |movie|
      hash = {:tweets_count => -movie.tweets_count, :facebook_feeds_count => -movie.facebook_feeds_count, :movie_casts_count => -movie.movie_casts_count, :critics_reviews_count => -movie.critics_reviews_count}
      Movie.update_counters movie.id, hash

      hash = {:tweets_count => movie.tweets.count, :facebook_feeds_count => movie.facebook_feeds.count, :movie_casts_count => movie.movie_casts.count, :critics_reviews_count => movie.critics_reviews.count}
      Movie.update_counters movie.id, hash
    end
  end

  def self.down
  end
end

