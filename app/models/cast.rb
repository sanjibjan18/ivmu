class Cast < ActiveRecord::Base
  $config = YAML.load_file(File.join(File.dirname(__FILE__), '../../config/database.yml'))
  self.establish_connection  $config["muvi_extract"]

  has_many :movie_casts
  has_many :movies


  def image
    self.thumbnail_image.blank?? '/images/no-image.jpg' : "/thumbnails/#{self.thumbnail_image.to_s}.png"
  end
end

