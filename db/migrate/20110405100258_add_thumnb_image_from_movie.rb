class AddThumnbImageFromMovie < ActiveRecord::Migration
  def self.up
    Movie.all.each do |fc|
      fc.update_attributes(:poster => File.new(Rails.root.to_s + "/public/thumbnails/#{fc.thumbnail_image.to_s}.png") ) if File.exists?(Rails.root.to_s + "/public/thumbnails/#{fc.thumbnail_image.to_s}.png")
    end
  end

  def self.down
  end
end

