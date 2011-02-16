class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :oauth2_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  has_many :facebook_feeds
  
  def fetch_fb_feeds
    client = Mogli::Client.new(self.oauth2_token)
    fb_user = Mogli::User.find("me", client)

    likes = fb_user.likes
    friends = fb_user.friends
    likes.map{|like| self.facebook_feeds.create(:feed_type => 'likes', :value => like.name)} unless likes.blank?
    friends.map{|friend| self.facebook_feeds.create(:feed_type => 'friend', :value => friend.id)} unless friends.blank? 
  end
  
end
