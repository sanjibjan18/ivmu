class CreateVideos < ActiveRecord::Migration
    def self.connection
    Video.connection
  end
  def self.up
    drop_table :videos
     create_table :videos do |t|
       t.timestamps
     end
  end

  def self.down
  end
end

