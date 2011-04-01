class Celebrity < ActiveRecord::Base
  $config = YAML.load_file(File.join(File.dirname(__FILE__), '../../config/database.yml'))
  self.establish_connection  $config["muvi_extract"]

  has_attached_file :profile_picture, :styles => { :thumb=> "45x45#", :small  => "150x150#" }
  has_many :movie_casts


  def self.option_list
    list ||= self.order('name ASC').all.collect{|cl| [cl.name, cl.id] }
  end
end

