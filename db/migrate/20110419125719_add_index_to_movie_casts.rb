class AddIndexToMovieCasts < ActiveRecord::Migration
  def self.connection
    MovieCast.connection
  end
  def self.up
    add_index :movie_casts, :movie_id
    add_index :movie_casts, :celebrity_id
  end

  def self.down
    remove_index :movie_casts, :movie_id
    remove_index :movie_casts, :celebrity_id
  end
end

