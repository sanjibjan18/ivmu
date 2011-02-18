class CreateFriendShips < ActiveRecord::Migration
  def self.up
    create_table :friend_ships do |t|
      t.integer :user_id
      t.integer :friend_id

      t.timestamps
    end
  end

  def self.down
    drop_table :friend_ships
  end
end
