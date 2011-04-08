class CriticsReview < ActiveRecord::Base
  belongs_to :movie, :foreign_key => "movie_name"#, :counter_cache => true
  belongs_to :film_critic, :foreign_key => :film_critic_name

  scope :latest, order('review_date desc nulls last')

  def critic_image
    (self.rating.to_f >= 2.5)? '/images/thumbUp.png' : '/images/thumbDown.png'
  end

  def film_critic
    FilmCritic.where('name = ?', self.film_critic_name).first rescue ''
  end

  def film_critic_profile_image
    film_critic = FilmCritic.where('name = ?', self.film_critic_name).first
    return (film_critic.thumbnail_image.url(:thumb).to_s rescue '/images/no-logo.png')

  end

end

