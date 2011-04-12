class AddPosterUpdatedAtAndTrailerUpdatedAtMovies < ActiveRecord::Migration
  def self.connection
    Movie.connection
  end

  def self.up
  #  add_column :films, :poster_updated_at,   :datetime
  #  add_column :films, :trailer_updated_at,   :datetime

    Movie.all.each do |movie|
      hash = {}
      hash[:poster_updated_at] = Time.now unless movie.poster_file_name.blank?
      hash[:trailer_updated_at] = Time.now unless movie.trailer_file_name.blank?
      movie.update_attributes(hash)
    end

  end

  def self.down
  end
end

