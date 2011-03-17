class Cast < ActiveRecord::Base
  $config = YAML.load_file(File.join(File.dirname(__FILE__), '../../config/database.yml'))
  self.establish_connection  $config["muvi_extract"]


  has_many :movie_casts
  has_many :movies, :through => :movie_casts
end

