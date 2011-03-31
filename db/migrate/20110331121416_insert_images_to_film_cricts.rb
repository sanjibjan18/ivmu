class InsertImagesToFilmCricts < ActiveRecord::Migration
  def self.up
    rename_column :film_critics, :thumbnail_image, :thumb
    FilmCritic.all.each do |fc|
      fc.update_attributes(:thumbnail_image => File.new(Rails.root.to_s + "/public/thumbnails/#{fc.thumb.to_s}.png") ) if File.exists?(Rails.root.to_s + "/public/thumbnails/#{fc.thumb.to_s}.png")
    end
  end

  def self.down
  end
end

