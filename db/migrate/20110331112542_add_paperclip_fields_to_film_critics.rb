class AddPaperclipFieldsToFilmCritics < ActiveRecord::Migration
  def self.up
    add_column :film_critics, :thumbnail_image_file_name, :string
    add_column :film_critics, :thumbnail_image_content_type, :string
    add_column :film_critics, :thumbnail_image_file_size, :integer

  end

  def self.down
  end
end

