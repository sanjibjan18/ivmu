class FilmCritic < ActiveRecord::Base
  has_many :critics_reviews, :foreign_key => :film_critic_name

  has_attached_file :thumbnail_image, :styles => { :thumb=> "45x45#", :small  => "150x150#" }


  def self.option_list
    l ||= self.all.collect{|fc| [fc.name, fc.name] }
  end
end

