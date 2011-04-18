class LoadGenreDataFromMovie < ActiveRecord::Migration
  def self.up
    Movie.where('genre is not null').each do |movie|
      movie.update_attribute('genre', movie.genre)
    end
  end

  def self.down
  end
end

