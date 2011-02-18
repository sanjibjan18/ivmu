class CreateReviews < ActiveRecord::Migration
  def self.up
    create_table :reviews do |t|
      t.integer :user_id
      t.integer :movie_id
      t.boolean :seen_movie
      t.boolean :facebook
      t.boolean :twitter
      t.boolean :orkut
      t.integer :rating
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :reviews
  end
end
