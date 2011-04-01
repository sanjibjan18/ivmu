class CreateCelebrities < ActiveRecord::Migration
  def self.connection
    Celebrity.connection
  end
  def self.up
    create_table :celebrities do |t|
      t.string :name
      t.string :celebrity_type
      t.date :birthdate
      t.string :birthplace
      t.string :profile_picture_file_name
      t.string :profile_picture_content_type
      t.integer :profile_picture_file_size
      t.text :summary
      t.string :twitterid

      t.timestamps
    end
  end

  def self.down
    drop_table :celebrities
  end
end

