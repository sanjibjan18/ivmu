class CreateTopBoxOffices < ActiveRecord::Migration
  def self.up
    create_table :top_box_offices do |t|
      t.integer :movie_id
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :top_box_offices
  end
end
