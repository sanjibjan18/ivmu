class AddColumnsToVideos < ActiveRecord::Migration
  def self.connection
    Video.connection
  end
  def self.up
    add_column :videos, :trailer_file_name, :string
    add_column :videos, :trailer_content_type, :string
    add_column :videos, :trailer_file_size, :integer
    add_column :videos, :trailer_updated_at, :date
    add_column :videos, :movie_id, :integer

    add_index :videos, :movie_id
  end

  def self.down
  end
end

