class TweetReviewOrInterstForAlreadyCreatedData < ActiveRecord::Migration
  def self.up
    Movie.all.each do |movie|
       movie.tweets.each do |tweet|
         if (!movie.release_date.blank? && tweet.created_at.to_date < movie.release_date.to_date )
           tweet.update_attributes({:interest => true})
         end
       end
    end
  end

  def self.down
  end
end

