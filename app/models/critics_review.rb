class CriticsReview < ActiveRecord::Base
  belongs_to :movie

  scope :for_movie, lambda{|movie| where(:movie_id => movie.id)}
end

