class FilmCritic < ActiveRecord::Base
  has_many :critics_reviews, :foreign_key => :film_critic_name


  def self.option_list
    self.all.collect{|fc| [fc.organization, fc.name] }
  end
end

