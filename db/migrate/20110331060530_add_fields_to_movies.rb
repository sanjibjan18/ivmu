class AddFieldsToMovies < ActiveRecord::Migration
  def self.connection
    Movie.connection
  end
  def self.up
    add_column :films, :poster_file_name, :string
    add_column :films, :poster_content_type, :string
    add_column :films, :poster_file_size, :integer
    add_column :films, :poster_release_date, :date
    add_column :films, :trailer_file_name, :string
    add_column :films, :trailer_content_type, :string
    add_column :films, :trailer_file_size, :integer
    add_column :films, :trailer_release_date, :date
  end

  def self.down
  end
end

