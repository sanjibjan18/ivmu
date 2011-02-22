class AddFbItemIdFieldToFacebookFeeds < ActiveRecord::Migration
  def self.up
    add_column :facebook_feeds, :fb_item_id, :string
  end

  def self.down
  end
end
