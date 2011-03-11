class CriticsReview < ActiveRecord::Base
  belongs_to :movie
  belongs_to :critic_reviewer

  scope :for_movie, lambda{|movie| where(:movie_id => movie.id)}

  def critic_image
    (self.rating.to_f >= 2.5)? '/images/thumbUp.png' : '/images/thumbDown.png'
  end

end

