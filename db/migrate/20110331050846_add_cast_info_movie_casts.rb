class AddCastInfoMovieCasts < ActiveRecord::Migration
  def self.connection
    MovieCast.connection
  end
  def self.up
    add_column :movie_casts, :cast_name, :string
    add_column :movie_casts, :cast_thumbnail_file_name, :string
    add_column :movie_casts, :cast_thumbnail_content_type, :string
    add_column :movie_casts, :cast_thumbnail_file_size, :integer
  end

  def self.down
  end
end

