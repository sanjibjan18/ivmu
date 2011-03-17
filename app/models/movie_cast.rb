class MovieCast < ActiveRecord::Base
  $config = YAML.load_file(File.join(File.dirname(__FILE__), '../../config/database.yml'))
  self.establish_connection  $config["muvi_extract"]

  belongs_to :movie, :foreign_key => "movie_name"
  belongs_to :cast, :foreign_key => "cast_name"
end

