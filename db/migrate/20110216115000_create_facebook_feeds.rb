class CreateFacebookFeeds < ActiveRecord::Migration
  def self.up
    create_table :facebook_feeds do |t|
      t.integer :user_id
      t.string :feed_type
      t.string :value
      
      t.timestamps
    end
  end

  def self.down
    drop_table :facebook_feeds
  end
end
