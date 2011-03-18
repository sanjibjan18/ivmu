class Comment < ActiveRecord::Base

  include ActsAsCommentable::Comment
  has_ancestry

  #after_save :post_to_wall
 # after_save :post_to_twitter

  belongs_to :commentable, :polymorphic => true
  belongs_to :user
  default_scope :order => 'created_at DESC'
  validates :comment , :presence => true
  scope :parent, where('ancestry IS NULL')

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  # NOTE: Comments belong to a user
  belongs_to :user

  def post_to_wall
    unless self.user.facebook_omniauth.blank?
      begin
        client = Mogli::Client.new(self.user.facebook_token)
        @myself  = Mogli::User.find("me", client)
        post = Mogli::Post.new(:message => self.comment)
        @myself.feed_create(post)
      rescue Mogli::Client::OAuthException
        #getting this strange exception. (#506) Duplicate status message
        #TODO handle this exception
      end
    end
  end

  def post_to_twitter
    unless self.user.twitter_omniauth.blank?
      begin
        self.user.twitter.update("#{self.comment}")
      rescue Twitter::Unauthorized
      end
    end
  end

end

