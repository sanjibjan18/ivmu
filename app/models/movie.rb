class Movie < ActiveRecord::Base
  #TODO: setting-up external database. This works but doesn't look nice. try using some plugin.
  $config = YAML.load_file(File.join(File.dirname(__FILE__), '../../config/database.yml'))
  self.establish_connection  $config["muvi_extract"]
  set_table_name 'films'

  acts_as_commentable
  # has_friendly_id :name
  has_permalink [:name], :update => true

  def to_param
    permalink
  end

  has_many :reviews
  has_many :reviwers, :through => :reviews, :source => :user
  has_many :recommendations
  has_many :tweets
  has_many :facebook_feeds
  has_many :critics_reviews, :foreign_key => 'movie_name' , :primary_key => 'name'
  has_one :meta_detail

  has_many :movie_casts
  has_many :casts, :through => :movie_casts
  has_many :directors, :through => :movie_casts, :source => :cast, :conditions => { "movie_casts.cast_type" => "director" }
  has_many :actors, :through => :movie_casts, :source => :cast, :conditions => { "movie_casts.cast_type" => "actor" }

  accepts_nested_attributes_for :meta_detail, :allow_destroy => true

  scope :find_using_id, lambda {|perm| where("permalink = ?", perm) }
  scope :latest, order('release_date desc nulls last')
  scope :limit, lambda{|l| limit(limit) }
  scope :name_is_not_blank, where("name IS NOT NULL")
  scope :released, where("release_date <= ? ", Date.today)
  scope :comming_soon_movies, where("release_date > ? ", Date.today)

  def banner_image
    self.thumbnail_image.blank?? '/images/no-logo.png' : "/thumbnails/#{self.thumbnail_image.to_s}.png"
  end

  def banner_image_thumb
    self.thumbnail_image.blank?? '/images/no-logo.png' : "/thumbnails/#{self.thumbnail_image.to_s}.png"
  end
  
  def average_rating
    reviews.blank? ? 'No ratings yet' : reviews.select("SUM(rating) as total").first.total.to_i / reviews.count
  end

  def average_rating_percent
    reviews.blank? ? 0 : (100 * reviews.select("SUM(rating) as total").first.total.to_i) / (reviews.count * 5)
  end

  def average_critics_reviews_rating_percent
    critics_reviews.blank? ? 0 : (100 * critics_reviews.select("SUM(rating) as total").first.total.to_i) / (critics_reviews.count * 5)
  end

  def fb_friends_liked(user)
    user.facebook_friend_likes(user.facebook_omniauth.uid).by_fb_item_id(self.fbpage_id) unless user.facebook_omniauth.blank?
  end


  def self.fetch_tweets_and_facebook_feeds
    delay = 0
    Movie.latest.each do |movie|
      Tweet.delay({:run_at => delay.minutes.from_now}).fetch_tweet_for_movie(movie)
      FacebookFeed.delay({:run_at => delay.minutes.from_now}).fetch_all_post_for_movie(movie)
      delay += 15
    end
  end

  def friend_likes(user) # this method is used in movie show
    return [] if user.blank? || user.facebook_friends.blank?
    FacebookFeed.friend_likes.friends_ids(user.facebook_friends_ids).movie_page_id(self.fbpage_id).limit(4)
  end

  def self.top_box_office(limit_to)
    self.order(:release_date).order(:gross_revenue).limit(limit_to)
  end
  
  def self.top_trending(limit_to)
    #self.select('films.*, SUM(tweets.id) as no_of_tweets').joins(:tweets).order("no_of_tweets").order(4)
  end
end

