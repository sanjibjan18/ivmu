class CreateMovieCasts < ActiveRecord::Migration
  def self.connection
    MovieCast.connection
  end
  def self.up
    create_table :movie_casts do |t|
      t.string :movie_name
      t.string :cast_name
      t.timestamps
    end
    add_index :movie_casts, :movie_name
    add_index :movie_casts, :cast_name
  end

  def self.down
    remove_index :movie_casts, :movie_name
    remove_index :movie_casts, :cast_name
    drop_table :movie_casts
  end
end

