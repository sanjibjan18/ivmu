class AddTwitterScreenNameToUserProfile < ActiveRecord::Migration
  def self.up
    add_column :user_profiles, :twitter_screen_name, :string
  end

  def self.down
    remove_column :user_profiles, :twitter_screen_name
  end
end

