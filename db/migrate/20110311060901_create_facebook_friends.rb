class CreateFacebookFriends < ActiveRecord::Migration
  def self.up
    create_table :facebook_friends do |t|
      t.integer :user_id
      t.string :facebook_id

      t.timestamps
    end
  end

  def self.down
    drop_table :facebook_friends
  end
end
