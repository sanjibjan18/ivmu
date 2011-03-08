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
  has_many :critics_reviews
  has_one :meta_detail
  accepts_nested_attributes_for :meta_detail, :allow_destroy => true

  scope :find_using_id, lambda {|perm| where("permalink = ?", perm) }
  scope :latest, order('initial_release_date desc')
  #scope :limit, lambda{|l| limit(limit)}
  scope :name_is_not_blank, where("name IS NOT NULL")
  scope :comming_soon_movies, where("initial_release_date > ? ", Date.today)

  def banner_image
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

end

