class AddReviewsCountToMovies < ActiveRecord::Migration
  def self.connection
    Movie.connection
  end
  def self.up
    add_column :films, :reviews_count, :integer, :default => 0
    Movie.reset_column_information
    Movie.all.each do |movie|
      hash = {:tweets_count => movie.tweets.count, :facebook_feeds_count => movie.facebook_feeds.count, :movie_casts_count => movie.movie_casts.count, :critics_reviews_count => movie.critics_reviews.count, :reviews_count => movie.reviews.count}
      Movie.update_counters movie.id, hash
    end

  end

  def self.down
  end
end

