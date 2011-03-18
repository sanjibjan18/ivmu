class CriticsReview < ActiveRecord::Base
  belongs_to :movie, :foreign_key => "movie_name"
  belongs_to :film_critic, :foreign_key => :film_critic_name

  scope :latest, order('review_date desc nulls last')

  def critic_image
    (self.rating.to_f >= 2.5)? '/images/thumbUp.png' : '/images/thumbDown.png'
  end

  def film_critic
    FilmCritic.where('name = ?', self.film_critic_name).first rescue ''
  end

  def film_critic_profile_image
    profile = FilmCritic.where('name = ?', self.film_critic_name).first
    if profile.blank? || profile.thumbnail_image.blank?
      return  "/images/jason.jpg"
    else
      return  "/thumbnails/#{profile.thumbnail_image.to_s}.png"
    end
  end

end

