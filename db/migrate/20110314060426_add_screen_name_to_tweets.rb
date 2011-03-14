class AddScreenNameToTweets < ActiveRecord::Migration
  def self.up
    add_column :tweets, :twitter_screen_name, :string
  end

  def self.down
    remove_column :tweets, :twitter_screen_name
  end
end

