class Review < ActiveRecord::Base
  MAX_RATING = 5
  belongs_to :movie
  belongs_to :user
  after_save :post_to_wall

  def post_to_wall
    unless self.user.facebook_token.blank?
      if self.facebook
        begin
          client = Mogli::Client.new(self.user.token)
          @myself  = Mogli::User.find("me", client)
          post = Mogli::Post.new(:message => self.description)
          @myself.feed_create(post)
        rescue Mogli::Client::OAuthException
          # getting this strange exception. (#506) Duplicate status message
          #TODO handle this exception
        end
      end
    end
  end

  scope :for_movie, lambda{|movie| where(:movie_id => movie.id)}
end

