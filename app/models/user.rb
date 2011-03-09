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

  scope :all_without_admin, where(:is_admin => false)

  def facebook_token
    facebook_omniauth.token
  end

  def fetch_fb_feeds
    unless self.facebook_omniauth.blank?
      movie_page_ids = Movie.limit(6).collect(&:fbpage_id)
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
                if movie_page_ids.include?(friend_like.id.to_s)
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
   self.reviews.where(:movie_id => movie.id).exists? ? true : false
  end

  def has_user_token?(provider, uid)
    self.user_tokens.where('provider = ? and uid = ? ', provider, uid).exists? ? false : true
  end

  def display_name
    self.user_profile.display_name rescue ''
  end

  def my_rating(movie)
    review = self.reviews.for_movie(movie).first
    review.rating unless review.blank?
  end

  def create_user_from_omniauth(omniauth)
    self.email = (omniauth['extra']['user_hash']['email'] rescue '' ) if omniauth['provider'] == 'facebook'
    self.build_user_profile(user_info_from_omniauth(omniauth))
    self.user_tokens.build(hash_from_omniauth(omniauth))
  end

  def twitter
    @twitter_user ||= Twitter::Client.new(:oauth_token => self.twitter_omniauth.token, :oauth_token_secret => self.twitter_omniauth.secret) rescue nil
  end


  def hash_from_omniauth(omniauth)
    { :provider => omniauth['provider'], :uid => omniauth['uid'],
      :token => (omniauth['credentials']['token'] rescue nil), :secret => (omniauth['credentials']['secret'] rescue nil)
    }
  end

   def friends_liked_movie(movie)
     self.facebook_friend_likes.find_all_by_fb_item_id(movie.fbpage_id) rescue []
   end

  def create_user_tokens(omniauth)
    self.user_tokens.create!(self.hash_from_omniauth(omniauth) )
    self.update_user_profile(omniauth)
  end

  def update_user_profile(omniauth)
    if self.user_profile.blank?
      UserProfile.create!(user_info_from_omniauth(omniauth).merge!(:user_id => self.id))
      self.reload
    end
    self.user_profile.update_attribute("twitter_screen_name", (omniauth['extra']['user_hash']['screen_name'] rescue '') ) if omniauth['provider'] == "twitter"
  end

  protected


  def user_info_from_omniauth(omniauth)
    user_info = { }
    case omniauth['provider']
    when 'facebook'
      user_info[:display_name] = (omniauth['extra']['user_hash']['name'] rescue '')
    when 'twitter'
      user_info[:display_name] = user_info[:twitter_screen_name] = (omniauth['extra']['user_hash']['screen_name'] rescue '')
    end
    user_info
  end







end

