class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :oauth2_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :oauth2_token, :display_name, :agreement
  attr_accessor :agreement
  validates_uniqueness_of :display_name
  validates_presence_of :agreement, :message => 'should be accepted.'
  
  has_many :facebook_feeds
  has_many :facebook_friends, :class_name => 'FacebookFeed', :conditions => {:feed_type => 'friend'}
  has_many :facebook_likes, :class_name => 'FacebookFeed', :conditions => {:feed_type => 'likes'}
  has_many :reviews
  #has_many :reviewed_movies, :through => :reviews, :source => :movie, :foreign_key => :movie_id
  has_many :comments
  has_many :friend_ships
  has_many :friends, :through => :friend_ships, :class_name => 'User'
  has_many :recommendations
  has_one :user_profile
    
  scope :facebook_friend_likes, lambda{|fbid|  facebook_likes.where(:fbid => fbid)}
  
  def fetch_fb_feeds
    client = Mogli::Client.new(self.oauth2_token)
    fb_user = Mogli::User.find("me", client)

    likes = fb_user.likes
    friends = fb_user.friends
    #Store current user's likes
    likes.map{|like| self.facebook_feeds.create(:feed_type => 'likes', :value => like.name, :fbid => self.oauth2_uid)} unless likes.blank?
    
    unless friends.blank? 
      friends.each do |friend|
        #Fetch and store current user's friends list
        self.facebook_feeds.create(:feed_type => 'friend', :value => friend.id, :fbid => self.oauth2_uid) if self.facebook_friends.where(:value => friend.id).first.blank? 
        
        #Fetch and store friends' likes.
        friend_likes = friend.likes
        unless friend_likes.blank?
          friend_likes.each do |friend_like|
            self.facebook_feeds.create(:feed_type => 'friend_likes', :value => friend_like.name, :fbid => friend.id)
          end  
        end
      end  
    end
  end
  
  def reviwed_movie?(movie)
    #reviewed_movies.include?(movie)
    self.reviews.where(:movie_id => movie.id).exists? ? false : true
  end
 
  def my_rating(movie)
    review = self.reviews.for_movie(movie).first
    review.rating unless review.blank?
  end
end
