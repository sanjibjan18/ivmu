class Comment < ActiveRecord::Base

  include ActsAsCommentable::Comment
  after_save :post_to_wall
  
  belongs_to :commentable, :polymorphic => true
  belongs_to :user
  default_scope :order => 'created_at ASC'

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  # NOTE: Comments belong to a user
  belongs_to :user
  
  def post_to_wall
    begin
      client = Mogli::Client.new(self.user.oauth2_token)
      @myself  = Mogli::User.find("me", client)
      post = Mogli::Post.new(:message => self.comment)
      @myself.feed_create(post)
    rescue Mogli::Client::OAuthException
      #getting this strange exception. (#506) Duplicate status message
      #TODO handle this exception
    end  
  end
end
