class RemoveTableMovieCasts < ActiveRecord::Migration
  def self.connection
    MovieCast.connection
  end
  def self.up
    remove_index :movie_casts, :movie_name
    remove_index :movie_casts, :cast_name
    drop_table :movie_casts

    create_table :movie_casts do |t|
      t.integer :movie_id
      t.integer :cast_id
      t.timestamps
    end
    add_index :movie_casts, :movie_id
    add_index :movie_casts, :cast_id

  end

  def self.down
  end
end

