class Movie < ActiveRecord::Base
  #TODO: setting-up external database. This works but doesn't look nice. try using some plugin.
  $config = YAML.load_file(File.join(File.dirname(__FILE__), '../../config/database.yml'))
  self.establish_connection  $config["muvi_extract"]
  set_table_name 'films'
   
  acts_as_commentable 
  has_many :reviews
  has_many :reviwers, :through => :reviews, :source => :user
  has_many :recommendations
  
  scope :latest, order('initial_release_date desc')
  scope :limit, lambda{|limit| limit(limit)}
  
  def average_rating
    reviews.blank? ? 'No ratings yet' : reviews.select("SUM(rating) as total").first.total.to_i / reviews.count
  end
  
  def average_rating_percent
    reviews.blank? ? 0 : (100 * reviews.select("SUM(rating) as total").first.total.to_i) / (reviews.count * 5)
  end
 
  def fb_friends_liked(user)
    #user.facebook_likes.facebook_friend_likes(user.oauth2_uid).like_name(self.name)
  end
  
end
