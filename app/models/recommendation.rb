class Recommendation < ActiveRecord::Base
  belongs_to :movie
  belongs_to :user
  has_many :recommended_tos
  
  after_save :mail_friends
  
  def friends_emails
    recommended_tos.map(&:email)
  end
  
  def mail_friends
    #TODO move this to delayed job
    RecommendationMail.send_recommendation(friends_emails, "Movie recommendation: #{self.movie.name}", self.message).deliver
  end
end
