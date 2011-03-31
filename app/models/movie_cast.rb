class MovieCast < ActiveRecord::Base
  $config = YAML.load_file(File.join(File.dirname(__FILE__), '../../config/database.yml'))
  self.establish_connection  $config["muvi_extract"]

  belongs_to :movie
  belongs_to :cast
  has_attached_file :cast_thumbnail, :styles => { :thumb=> "45x45#", :small  => "150x150#" }
  scope :actors, where("cast_type = ? ", "actor")
end

