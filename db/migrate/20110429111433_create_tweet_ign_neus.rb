class CreateTweetIgnNeus < ActiveRecord::Migration
  def self.up
    create_table :tweet_ign_neus do |t|
      t.integer :user_id
      t.integer :movie_id
      t.string :tweet_id
      t.string :twitter_id
      t.string :twitter_screen_name
      t.text :content
      t.boolean :interest, :default => false
      t.datetime :tweeted_on
      t.string :review
      t.integer :rating

      t.timestamps

    end
    add_index :tweet_ign_neus, :user_id
    add_index :tweet_ign_neus, :movie_id
    add_index :tweet_ign_neus, :review
    add_index :tweet_ign_neus, :twitter_id
    add_index :tweet_ign_neus, :interest
  end

  def self.down
    drop_table :tweet_ign_neus
  end
end

