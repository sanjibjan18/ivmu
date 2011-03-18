class AddCastTypeMovieCasts < ActiveRecord::Migration
  def self.connection
    MovieCast.connection
  end

  def self.up
    add_column :movie_casts, :cast_type, :string
    add_column :movie_casts, :role_name, :string
  end

  def self.down
    remove_column :movie_casts, :cast_type
    remove_column :movie_casts, :role_name
  end
end

