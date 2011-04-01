class AddCelebrityIdToMovieCasts < ActiveRecord::Migration
  def self.connection
    MovieCast.connection
  end
  def self.up
    add_column :movie_casts, :celebrity_id, :integer
  end

  def self.down
    remove_column :movie_casts, :celebrity_id
  end
end

