class CriticsReview < ActiveRecord::Base
  belongs_to :movie, :counter_cache => true
  belongs_to :film_critic


  #in latest copy remove the film_critic_name, movie_name column

  scope :latest, order('review_date desc nulls last')

  def critic_image
    (self.rating.to_f >= 2.5)? '/images/thumbUp.png' : '/images/thumbDown.png'
  end


end

