class AddMovieIdToFacebookFeeds < ActiveRecord::Migration
  def self.up
    add_column :facebook_feeds, :movie_id, :integer
  end

  def self.down
    remove_column :facebook_feeds, :movie_id
  end
end
