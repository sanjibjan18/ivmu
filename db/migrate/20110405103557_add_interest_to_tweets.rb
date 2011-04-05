class AddInterestToTweets < ActiveRecord::Migration
  def self.up
    add_column :tweets, :interest, :boolean, :default => false
  end

  def self.down
    remove_column :tweets, :interest
  end
end

