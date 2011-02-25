class CreateTweets < ActiveRecord::Migration
  def self.up
    create_table :tweets do |t|
      t.integer :user_id
      t.integer :movie_id
      t.text :content

      t.timestamps
    end
    add_index :tweets, :user_id
    add_index :tweets, :movie_id
  end

  def self.down
    drop_table :tweets
  end
end

