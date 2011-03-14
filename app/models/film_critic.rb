class FilmCritic < ActiveRecord::Base
  has_many :critics_reviews, :foreign_key => :film_critic_name
end

