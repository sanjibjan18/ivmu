class AddFacebookNameAndPostedOnToFacebookFeeds < ActiveRecord::Migration
  def self.up
    add_column :facebook_feeds, :facebook_name, :string
    add_column :facebook_feeds, :posted_on, :date
  end

  def self.down
    remove_column :facebook_feeds, :posted_on
    remove_column :facebook_feeds, :facebook_name
  end
end
