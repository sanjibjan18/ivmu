class ChangeTweetReview < ActiveRecord::Migration
  def self.up
    ['positive', 'negative', 'neutral', 'ignore'].each do |review|
      Tweet.where('review = ?', review).each do |tweet|
        tweet.update_attributes({:review => review[0..2] })
      end
    end
  end

  def self.down
  end
end

