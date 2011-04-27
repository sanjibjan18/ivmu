class FacebookFeed < ActiveRecord::Base
  belongs_to :user
  belongs_to :movie, :counter_cache => true

  scope :like_name, lambda{|name| where("value like ? ", "#{name}%") }
  scope :by_fb_item_id, lambda{|item_id| where(:fb_item_id => item_id) }
  scope :by_fbid, lambda{|fbid| where(:fbid => fbid) }
  scope :friends_ids, lambda{|ids| where("fbid in (?)", ids) }
  scope :movie_page_id, lambda{|page_id| where("fb_item_id = ?", page_id) }
  scope :latest,  order('posted_on desc nulls last')
  scope :posts, where('feed_type = ? or feed_type = ?', 'public_post', 'friends_post')
  scope :friend_likes, where('feed_type = ? or feed_type = ?', 'friend_likes', 'likes')
  scope :all_posts, where('feed_type = ? or feed_type = ?', 'friends_post', 'public_post')


  def self.fetch_all_post_for_movie(movie)
    posts = Mogli::Model::search("#{movie.name}", nil, {:type => 'post', :limit => 400})
    FacebookFeed.create_facebook_feed(posts, movie) # create facebook posts
    while !posts.next_url.blank?  # fetch next method in mogli client append the data to same array so we check untill next url blank
      additional_posts = posts.fetch_next # retuns the pagnation post from next url
      FacebookFeed.create_facebook_feed(additional_posts, movie)
    end
  end

  def self.create_facebook_feed(array, movie)
    array.each do |post|
      if post.type == "status"
        begin
          unless movie.facebook_feeds.where('fb_item_id = ?', post.id.to_s).exists?
            post = movie.facebook_feeds.create(:feed_type => 'public_post', :value => post.message, :fbid => post.from.id, :fb_item_id => post.id.to_s, :movie_id => movie.id, :facebook_name => post.from.name, :posted_on => post.created_time.to_date)
            Activity.create_log_for_each_friend(post, movie, 'said', post.from.id.to_s,  post.from.name )
          end
        rescue
          # this for any errors
        end
      end
    end
  end



end

