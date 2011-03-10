class CreateTwitterFriends < ActiveRecord::Migration
  def self.up
    create_table :twitter_friends do |t|
      t.integer :user_id
      t.string :twitter_id
      t.string :friend_type
      t.timestamps
    end
  end

  def self.down
    drop_table :twitter_friends
  end
end

