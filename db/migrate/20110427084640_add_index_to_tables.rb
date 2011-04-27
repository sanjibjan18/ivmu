class AddIndexToTables < ActiveRecord::Migration
  def self.up
    add_index :top_box_offices, :movie_id
    add_index :top_trendings, :movie_id
    add_index :facebook_feeds, :movie_id
    add_index :facebook_feeds, :feed_type
    add_index :facebook_feeds, :fbid
    add_index :facebook_feeds, :fb_item_id
    add_index :facebook_friends, :user_id
    add_index :facebook_friends, :facebook_id
    add_index :meta_details, :movie_id
    add_index :pages, :reference
    add_index :reviews, :user_id
    add_index :reviews, :movie_id
    add_index :tweets, :twitter_id
    add_index :tweets, :review
    add_index :tweets, :interest
    add_index :twitter_friends,:user_id
    add_index :twitter_friends,:twitter_id
    add_index :user_profiles, :user_id
    add_index :user_tokens, :provider
    add_index :user_tokens, :user_id
    add_index :user_tokens, :uid
    add_index :activities, :subject_id
    add_index :activities, :subject_type
    add_index :activities,:user_id
    add_index :activities, :secondary_subject_id
    add_index :activities, :secondary_subject_type
    add_index :activities, :facebook_id
    add_index :critics_reviews, :movie_id
    add_index :critics_reviews, :film_critic_id
  end

  def self.down
  end
end

