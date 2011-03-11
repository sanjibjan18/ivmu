class AlterValueStringToTextInFacebookFeeds < ActiveRecord::Migration
  def self.up
    change_column :facebook_feeds, :value, :text
  end

  def self.down
    change_column :facebook_feeds, :value, :string
  end
end

