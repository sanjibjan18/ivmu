class Movie < ActiveRecord::Base
  #TODO: setting-up external database. This works but doesn't look nice. try using some plugin.
  $config = YAML.load_file(File.join(File.dirname(__FILE__), '../../config/database.yml'))
  self.establish_connection  $config["muvi_extract"]
  set_table_name 'films'
  set_primary_key :id
  acts_as_commentable
  # has_friendly_id :name
  has_permalink [:name], :update => true
  has_attached_file :poster, :styles => { :thumb=> "35x35#", :medium  => "130x200#" },
                :url => "/system/:attachment/:id/:style/:filename",
                :path => ":rails_root/public/system/:attachment/:id/:style/:basename.:extension"
  has_attached_file :trailer

  def to_param
    permalink
  end
  serialize :genre


  has_many :reviews , :dependent => :destroy
  has_many :reviwers, :through => :reviews, :source => :user
  has_many :recommendations, :dependent => :destroy
  has_many :tweets, :dependent => :destroy
  has_many :facebook_feeds, :dependent => :destroy
  has_many :critics_reviews, :dependent => :destroy
  has_one :meta_detail, :dependent => :destroy
  has_one :video, :dependent => :destroy

  has_many :movie_casts, :dependent => :destroy
  #to do better way .

  has_many :actors,  :class_name => 'MovieCast', :conditions => { "cast_type" => "actor" }
  has_many :crew_members,  :class_name => 'MovieCast', :conditions => [ "cast_type != ?", 'actor' ]
#  has_many :producers,  :class_name => 'MovieCast', :conditions => { "cast_type" => "producer" }
 # has_many :musics,  :class_name => 'MovieCast', :conditions => { "cast_type" => "musics" }
 # has_many :writers,  :class_name => 'MovieCast', :conditions => { "cast_type" => "writer" }
 # has_many :cinematographers,  :class_name => 'MovieCast', :conditions => { "cast_type" => "cinematographer" }
 # has_many :distributors,  :class_name => 'MovieCast', :conditions => { "cast_type" => "distributor" }
 # has_many :editors,  :class_name => 'MovieCast', :conditions => { "cast_type" => "editor" }

  accepts_nested_attributes_for :meta_detail,:video, :movie_casts, :critics_reviews,  :allow_destroy => true
  accepts_nested_attributes_for :movie_casts, :reject_if => proc { |attributes| attributes['celebrity_id'].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :actors, :reject_if => proc { |attributes| attributes['celebrity_id'].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :crew_members, :reject_if => proc { |attributes| attributes['celebrity_id'].blank? }, :allow_destroy => true


  scope :find_using_id, lambda {|perm| where("permalink = ?", perm) }
  scope :latest, order('release_date desc nulls last')
  scope :sort_by_release_date_asc, order('release_date asc nulls last')
  scope :sort_by_user_interest_desc, order('user_percent desc nulls last')
  scope :sort_by_media_updated_date, order('media_updated_date desc nulls last')
  scope :limit, lambda{|l| limit(limit) }
  scope :name_is_not_blank, where("name IS NOT NULL")
  scope :released, where("release_date <= ?", Date.today)
  scope :comming_soon_movies, where("release_date > ?  or release_date IS NULL", Date.today)
  scope :name_without_dictionary_word, where("dictionary_word = ?", false)

  def banner_image
    self.poster_file_name.blank?? '/images/no-logo.png' : self.poster.url(:medium)
  end

  def banner_image_thumb
   self.poster_file_name.blank?? '/images/no-logo.png' : self.poster.url(:thumb)
  end

  def average_rating
    reviews.blank? ? 'No ratings yet' : reviews.select("SUM(rating) as total").first.total.to_i / reviews.count
  end

  def average_rating_percent
    #reviews.blank? ? 0 : (100 * reviews.select("SUM(rating) as total").first.total.to_i) / (reviews.count * 5) rescue 0
    tweets.blank? ? 0 : (100 * tweets.select("SUM(rating) as total").first.total.to_i) / tweets.count(:all,:conditions=>["interest = ?","f"]) rescue 0
  end

  def average_rating_count
    #reviews.blank? ? 0 : reviews.count
    tweets.blank? ? 0 : tweets.count rescue 0

  end

  def average_critics_reviews_rating_percent
    critics_reviews.blank? ? 0 : (100 * critics_reviews.select("SUM(rating) as total").first.total.to_i) / (critics_reviews.count * 5)
  end

  def fb_friends_liked(user)
    #user.facebook_friend_likes(user.facebook_omniauth.uid).by_fb_item_id(self.fbpage_id) unless user.facebook_omniauth.blank?
    return 0 if user.blank? || user.facebook_friends.blank?
    FacebookFeed.friend_likes.friends_ids(user.facebook_friends_ids).movie_page_id(self.fbpage_id).count
  end


  def self.fetch_tweets_and_facebook_feeds
    delay = 0
    Movie.name_without_dictionary_word.latest.each do |movie|
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
    []
  end

  def self.update_reviews_precentage
    Movie.latest.includes(:tweets, :reviews, :critics_reviews).each do |movie|
      review_count = movie.reviews.blank? ? 0 : (100 * movie.reviews.select("SUM(rating) as total").first.total.to_i) / (movie.reviews.count * 5) rescue 0
      tweet_count = movie.tweets.blank? ? 0 : (100 * movie.tweets.select("SUM(rating) as total").first.total.to_i) / movie.tweets.count(:all,:conditions=>["interest = ?","f"]) rescue 0
      critics_percent = movie.critics_reviews.blank? ? 0 : (100 * movie.critics_reviews.select("SUM(rating) as total").first.total.to_i) / (movie.critics_reviews.count * 5)
      if review_count == 0 || tweet_count == 0
        user_percent =  (review_count + tweet_count)
      else
        user_percent =  (review_count + tweet_count)/ 2 rescue 0
      end
      movie.update_attribute('critics_percent', critics_percent) unless movie.critics_percent == critics_percent
      movie.update_attribute('user_percent',  user_percent) unless movie.user_percent == user_percent
    end
  end


  def self.update_top_box_office
    TopBoxOffice.destroy_all
    Movie.top_box_office(4).each_with_index do |movie, idx|
      TopBoxOffice.create({:movie_id => movie.id, :position => idx})
    end
  end

  def self.update_top_trending
    TopTrending.destroy_all
    date = (Date.today - 30).to_date.to_s
    Movie.find_by_sql("select id, (tweets_count+facebook_feeds_count) as count from films where release_date >='#{date}' order by count DESC limit 4;").each_with_index do |movie, idx|
      TopTrending.create({:movie_id => movie.id, :position => idx})
    end
  end

  def self.update_tweets_count
    Movie.latest.each do |movie|
      movie.update_attribute('tweets_count', movie.tweets.reviews.pos_or_neg.count)
    end
  end

  def self.update_all_counters
    Movie.latest.all.each do |movie|
      hash = {:tweets_count => -movie.tweets_count, :facebook_feeds_count => -movie.facebook_feeds_count, :movie_casts_count => -movie.movie_casts_count, :critics_reviews_count => -movie.critics_reviews_count}
      Movie.update_counters movie.id, hash

      hash = {:tweets_count => movie.tweets.reviews.pos_or_neg.count, :facebook_feeds_count => movie.facebook_feeds.count, :movie_casts_count => movie.movie_casts.count, :critics_reviews_count => movie.critics_reviews.count}
      Movie.update_counters movie.id, hash
    end
  end

end

