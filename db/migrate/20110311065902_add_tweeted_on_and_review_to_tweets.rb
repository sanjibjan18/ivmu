class AddTweetedOnAndReviewToTweets < ActiveRecord::Migration
  def self.up
    add_column :tweets, :tweeted_on, :datetime
    add_column :tweets, :review, :boolean, :default => false
  end

  def self.down
    remove_column :tweets, :review
    remove_column :tweets, :tweeted_on
  end
end

