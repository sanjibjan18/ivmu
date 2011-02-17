class AddFieldToFacebookFeeds < ActiveRecord::Migration
  def self.up
    add_column :facebook_feeds, :fbid, :string
  end

  def self.down
  end
end
