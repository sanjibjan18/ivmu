class Celebrity < ActiveRecord::Base
  $config = YAML.load_file(File.join(File.dirname(__FILE__), '../../config/database.yml'))
  self.establish_connection  $config["muvi_extract"]

  has_attached_file :profile_picture, :styles => { :thumb=> "45x45#", :small  => "150x150#" }
  has_many :movie_casts
  scope :order_by_name, order('name asc nulls last')

  def self.option_list
    list ||= self.order_by_name.all.collect{|cl| [cl.name, cl.id] }
  end

  def image
    self.profile_picture_file_name.blank?? '/images/no-image.jpg' : self.profile_picture.url(:small).to_s
  end
end

