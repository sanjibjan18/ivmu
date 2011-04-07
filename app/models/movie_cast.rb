class MovieCast < ActiveRecord::Base
  $config = YAML.load_file(File.join(File.dirname(__FILE__), '../../config/database.yml'))
  self.establish_connection  $config["muvi_extract"]

  belongs_to :movie, :counter_cache => true
  belongs_to :cast
  belongs_to :celebrity
  has_attached_file :cast_thumbnail, :styles => { :thumb=> "45x45#", :small  => "150x150#" }

  scope :actors, where("cast_type = ? ", "actor")
  scope :directors, where("cast_type = ?", "director")
  scope :producers, where("cast_type = ?", "producer")
  scope :writers, where("cast_type = ?", "writer")
  scope :cinematographers, where("cast_type = ?", "cinematographer")
  scope :editors, where("cast_type = ?", "editor")
  scope :musics, where("cast_type = ?", "music")
  scope :actors, where("cast_type = ? ", "actor")
end

