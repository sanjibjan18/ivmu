class AddTweetsFetchedOnToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :tweets_fetched_on, :date
  end

  def self.down
    remove_column :users, :tweets_fetched_on
  end
end
