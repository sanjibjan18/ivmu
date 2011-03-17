class CreateMovieCasts < ActiveRecord::Migration
  def self.connection
    MovieCast.connection
  end
  def self.up
    create_table :movie_casts do |t|
      t.integer :movie_id
      t.integer :cast_id
      t.timestamps
    end
    add_index :movie_casts, :movie_id
    add_index :movie_casts, :cast_id
  end

  def self.down
    remove_index :movie_casts, :movie_id
    remove_index :movie_casts, :cast_id
    drop_table :movie_casts
  end
end

