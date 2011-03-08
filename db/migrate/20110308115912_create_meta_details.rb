class CreateMetaDetails < ActiveRecord::Migration
  def self.up
    create_table :meta_details do |t|
      t.integer :movie_id
      t.string :meta_title
      t.text :meta_keywords
      t.text :meta_description
      t.timestamps
    end
  end

  def self.down
    drop_table :meta_details
  end
end

