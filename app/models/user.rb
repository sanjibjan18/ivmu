class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :oauth2_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :oauth2_token, :agreement, :user_profile_attributes

  attr_accessor :agreement

  validates_presence_of :agreement, :message => 'should be accepted.'

  has_many :facebook_feeds
  #has_many :facebook_friends, :class_name => 'FacebookFeed', :conditions => {:feed_type => 'friend'}
  has_many :facebook_likes, :class_name => 'FacebookFeed', :conditions => {:feed_type => 'likes'}
  has_many :facebook_friend_likes, :class_name => 'FacebookFeed', :conditions => {:feed_type => 'friend_likes'}
  has_many :facebook_friends_posts, :class_name => 'FacebookFeed', :conditions => {:feed_type => 'friends_post'}

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
  has_many :twitter_friends
  has_many :facebook_friends

  scope :all_without_admin, where(:is_admin => false)
  accepts_nested_attributes_for :user_profile


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

      #store facebook friends of current user in facebook_friends table
      fb_user.friends.collect(&:id).each do |friend_id|
        unless self.facebook_friends.collect(&:facebook_id).include?(friend_id.to_s)
          self.facebook_friends.create!(:facebook_id => friend_id)
        end
      end

      #Store current user's likes
      unless likes.blank?
        likes.each do |like|
          self.facebook_feeds.create(:feed_type => 'likes', :value => like.name, :fbid => self.facebook_omniauth.uid, :fb_item_id => like.id, :posted_on => like.created_time.to_date, :facebook_name => fb_user.name) unless self.facebook_feeds.where(:fb_item_id => like.id).exists?
        end
      end

      unless friends.blank?
        friends.each do |friend|
          #Fetch and store current user's friends list
          #self.facebook_feeds.create(:feed_type => 'friend', :value => friend.id, :fbid => self.facebook_omniauth.uid, :fb_item_id => friend.id) unless self.facebook_friends.where(:value => friend.id).exists?

          #Fetch and store friends' likes.
          friend_likes = friend.likes
          unless friend_likes.blank?
            friend_likes.each do |friend_like|
              unless self.facebook_friends.where(:facebook_id => friend_like.id).exists?
                if movie_page_ids.include?(friend_like.id.to_s)
                  self.facebook_feeds.create(:feed_type => 'friend_likes', :value => friend_like.name, :fbid => friend.id, :fb_item_id => friend_like.id, :posted_on => friend_like.created_time.to_date, :facebook_name => friend.name)
                end
              end
            end
          end

          #Fetch and store friends' posts.
          friend.posts.each do |post|
            unless post.message.blank?
              Movie.latest.limit(6).compact.each do |movie|
                if post.message.match("#{movie.name}")
                  self.facebook_friends_posts.create(:feed_type => 'friends_post', :value => post.message, :fbid => friend.id, :fb_item_id => post.id, :movie_id => movie.id,:facebook_name => friend.name, :posted_on => post.created_time.to_date)
                end
              end # movie end
            end # unless post message blank
          end # each post end

        end
      end
    end
  end


  def image
     self.user_profile.profile_image_file_name.blank?? "/images/no-profile.png" : self.user_profile.profile_image.url(:thumb)
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

  def facebook_friends_ids
    self.facebook_friends.collect(&:facebook_id)
  end

  def create_user_from_omniauth(omniauth)
    self.email = (omniauth['extra']['user_hash']['email'] rescue '' ) if omniauth['provider'] == 'facebook'
    self.confirmed_at = Time.now
    self.build_user_profile(user_info_from_omniauth(omniauth))
    self.user_tokens.build(hash_from_omniauth(omniauth))
  end

  def twitter
    @twitter_user ||= Twitter::Client.new(:oauth_token => self.twitter_omniauth.token, :oauth_token_secret => self.twitter_omniauth.secret) rescue nil
  end

  def fetch_friends_from_twitter
    twitter.follower_ids.ids.each do |follower_id|
      self.twitter_friends.create(:twitter_id => follower_id, :friend_type => 'followers')
    end
    twitter.friend_ids.ids.each do |friend_id|
      self.twitter_friends.create(:twitter_id => friend_id, :friend_type => 'following')
    end
  end


  def hash_from_omniauth(omniauth)
    { :provider => omniauth['provider'], :uid => omniauth['uid'],
      :token => (omniauth['credentials']['token'] rescue nil), :secret => (omniauth['credentials']['secret'] rescue nil)
    }
  end

  def friends_tweet_for_movie(movie)
    twitter_friends_ids = self.twitter_friends.collect(&:twitter_id)
    return [] if twitter_friends_ids.blank?
    movie.tweets.where('twitter_id in (?)', twitter_friends_ids)
  end

  def friends_post_for_movie(movie)
    return [] if facebook_friends_ids.blank?
    movie.facebook_feeds.posts.latest.where('fbid in (?)', facebook_friends_ids).limit(4) rescue []
  end

  def friends_liked_movie(movie)
     self.facebook_friend_likes.where('fb_item_id = ?', movie.fbpage_id) rescue []
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

