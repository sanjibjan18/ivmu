class AddPosterOrTrailerReleaseDateMovies < ActiveRecord::Migration
  def self.connection
    Movie.connection
  end
  def self.up
    add_column :films, :media_updated_date, :date
  end

  def self.down
  end
end

