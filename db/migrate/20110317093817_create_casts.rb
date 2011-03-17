class CreateCasts < ActiveRecord::Migration
  def self.connection
    Cast.connection
  end

  def self.up
    create_table :casts do |t|
      t.string :name
      t.string :thumbnail_image

      t.timestamps
    end
  end

  def self.down
    drop_table :casts
  end
end

