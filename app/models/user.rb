class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :oauth2_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :oauth2_token, :display_name, :agreement
  attr_accessor :agreement

  validates_presence_of :agreement, :message => 'should be accepted.'

  has_many :facebook_feeds
  has_many :facebook_friends, :class_name => 'FacebookFeed', :conditions => {:feed_type => 'friend'}
  has_many :facebook_likes, :class_name => 'FacebookFeed', :conditions => {:feed_type => 'likes'}
  has_many :facebook_friend_likes, :class_name => 'FacebookFeed', :conditions => {:feed_type => 'friend_likes'}

  has_many :reviews
  #has_many :reviewed_movies, :through => :reviews, :source => :movie, :foreign_key => :movie_id
  has_many :comments
  has_many :friend_ships
  has_many :friends, :through => :friend_ships, :class_name => 'User'
  has_many :recommendations
  has_one :user_profile
  has_many :user_tokens
  has_one :facebook_omniauth, :class_name => "UserToken", :conditions => { :provider => 'facebook' }
  has_one :twitter_omniauth, :class_name => "UserToken", :conditions => { :provider => 'twitter' }
  has_many :tweets

  def facebook_token
    facebook_omniauth.token
  end

  def fetch_fb_feeds
    unless self.facebook_omniauth.blank?
      client = Mogli::Client.new(self.facebook_token)
      fb_user = Mogli::User.find("me", client)

      likes = fb_user.likes
      friends = fb_user.friends
      #Store current user's likes
      unless likes.blank?
        likes.each do |like|
          self.facebook_feeds.create(:feed_type => 'likes', :value => like.name, :fbid => self.facebook_omniauth.uid, :fb_item_id => like.id) unless self.facebook_feeds.where(:fb_item_id => like.id).exists?
        end
      end

      unless friends.blank?
        friends.each do |friend|
          #Fetch and store current user's friends list
          self.facebook_feeds.create(:feed_type => 'friend', :value => friend.id, :fbid => self.facebook_omniauth.uid, :fb_item_id => friend.id) unless self.facebook_friends.where(:value => friend.id).exists?

          #Fetch and store friends' likes.
          friend_likes = friend.likes
          unless friend_likes.blank?
            friend_likes.each do |friend_like|
              unless self.facebook_friends.where(:value => friend_like.id).exists?
                if Movie.where(:fbpage_id => friend_like.id).exists?
                  self.facebook_feeds.create(:feed_type => 'friend_likes', :value => friend_like.name, :fbid => friend.id, :fb_item_id => friend_like.id)
                end
              end
            end
          end
        end
      end
    end
  end

  def reviwed_movie?(movie)
    #reviewed_movies.include?(movie)
    self.reviews.where(:movie_id => movie.id).exists? ? false : true
  end

  def has_user_token?(provider, uid)
    self.user_tokens.where('provider = ? and uid = ? ', provider, uid).exists? ? false : true
  end

  def my_rating(movie)
    review = self.reviews.for_movie(movie).first
    review.rating unless review.blank?
  end

  def create_user_from_omniauth(omniauth)
    case omniauth['provider']
    when 'facebook'
      self.apply_facebook(omniauth)
    when 'twitter'
      self.apply_twitter(omniauth)
    end
    self.user_tokens.build(hash_from_omniauth(omniauth))
  end

  def twitter
    @twitter_user ||= Twitter::Client.new(:oauth_token => self.twitter_omniauth.token, :oauth_token_secret => self.twitter_omniauth.secret) rescue nil
  end


  protected

  def apply_facebook(omniauth)
    if (extra = omniauth['extra']['user_hash'] rescue false)
     self.email = (extra['email'] rescue '')
     userprofile(extra['name'])
    end
  end

  def apply_twitter(omniauth)
    if (extra = omniauth['extra']['user_hash'] rescue false)
       userprofile(extra['screen_name'], extra['screen_name'])
    end
  end

  def hash_from_omniauth(omniauth)
   { :provider => omniauth['provider'], :uid => omniauth['uid'],
     :token => (omniauth['credentials']['token'] rescue nil), :secret => (omniauth['credentials']['secret'] rescue nil)
   }
  end

  def userprofile(name=nil, twitter_name=nil)
    profile = self.build_user_profile
    profile.display_name = (name rescue '')
    profile.twitter_screen_name = twitter_name  unless twitter_name.nil?
  end


end

