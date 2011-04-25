class FacebookFeed < ActiveRecord::Base
  belongs_to :user
  belongs_to :movie, :counter_cache => true

  scope :like_name, lambda{|name| where("value like ? ", "#{name}%") }
  scope :by_fb_item_id, lambda{|item_id| where(:fb_item_id => item_id) }
  scope :friends_ids, lambda{|ids| where("fbid in (?)", ids) }
  scope :movie_page_id, lambda{|page_id| where("fb_item_id = ?", page_id) }
  scope :latest,  order('posted_on desc nulls last')
  scope :posts, where('feed_type = ? or feed_type = ?', 'public_post', 'friends_post')
  scope :friend_likes, where('feed_type = ? or feed_type = ?', 'friend_likes', 'likes')
  scope :all_posts, where('feed_type = ? or feed_type = ?', 'friends_post', 'public_post')

  def self.fetch_posts_for_films(user)
    movies = []
    ["Dabangg", "No One Killed Jessica"].each do |movie_name|
      movies << Movie.find_by_name(movie_name)
    end
    movies.compact!

    #UserToken.where('provider = ?','facebook').order('created_at DESC').each do |user_token|
      #user = user_token.user
      client = Mogli::Client.new(user.facebook_omniauth.token)
      fb_user = Mogli::User.find("me", client)
      likes = fb_user.likes
      friends = fb_user.friends

      fb_user.friends.collect(&:id).each do |friend_id|
        unless user.facebook_friends.collect(&:facebook_id).include?(friend_id.to_s)
          user.facebook_friends.create!(:facebook_id => friend_id)
        end
      end

      unless likes.blank?
        likes.each do |like|
          if movies.collect(&:fbpage_id).include?(like.id.to_s)
            unless user.facebook_feeds.where(:fb_item_id => like.id).exists?
              like = user.facebook_feeds.create(:feed_type => 'likes', :value => like.name, :fbid => user.facebook_omniauth.uid, :fb_item_id => like.id, :posted_on => like.created_time.to_date, :facebook_name => fb_user.name )
              movie = Movie.where('fbpage_id = ?', like.fb_item_id).first
              Activity.log_activity(like, movie, 'liked' , user.id)
            end
          end
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
              unless user.facebook_friends.where(:facebook_id => friend_like.id).exists?
                if movies.collect(&:fbpage_id).include?(friend_like.id.to_s)
                  like = user.facebook_feeds.create(:feed_type => 'friend_likes', :value => friend_like.name, :fbid => friend.id, :fb_item_id => friend_like.id, :posted_on => friend_like.created_time.to_date, :facebook_name => friend.name)
                  movie = Movie.where('fbpage_id = ?', like.fb_item_id).first
                  facebook_user_present_in_db = UserToken.where('uid = ?', friend.id).first
                  Activity.log_activity(like, movie, 'liked' , facebook_user_present_in_db.user.id) unless facebook_user_present_in_db.blank?
                end
              end
            end
          end
          #Fetch and store friends' posts.
          friend.posts.each do |post|
            unless post.message.blank?
              movies.each do |movie|
                if post.message.match("#{movie.name}")
                  unless user.facebook_friends_posts.where('movie_id = ? and fb_item_id = ?', movie.id, post.id ).exists?
                    post = user.facebook_friends_posts.create(:feed_type => 'friends_post', :value => post.message, :fbid => friend.id, :fb_item_id => post.id, :movie_id => movie.id, :facebook_name => friend.name, :posted_on => post.created_time.to_date)
                    Activity.log_activity(post, movie, 'posted on wall' , user.id)
                  end
                end
              end # movie end
            end # unless post message blank
          end # each post end
        end
      end
    #end
  end

  def self.fetch_all_post_for_movie(movie)
    facebook_users_in_muvi =  {}
    UserToken.where('provider = ?', 'facebook').collect { |p| facebook_users_in_muvi[p.uid] = p.user_id } # todo better way find all facebook user registered with ivmu

    posts = Mogli::Model::search("#{movie.name}", nil, {:type => 'post', :limit => 400})
    FacebookFeed.create_facebook_feed(posts, movie, facebook_users_in_muvi) # create facebook posts
    while !posts.next_url.blank?  # fetch next method in mogli client append the data to same array so we check untill next url blank
      additional_posts = posts.fetch_next # retuns the pagnation post from next url
      FacebookFeed.create_facebook_feed(additional_posts, movie, facebook_users_in_muvi)
    end
  end

  def self.create_facebook_feed(array, movie, facebook_users)
    array.each do |post|
      if post.type == "status"
        begin
          unless movie.facebook_feeds.where('fb_item_id = ?', post.id.to_s).exists?
            post = movie.facebook_feeds.create(:feed_type => 'public_post', :value => post.message, :fbid => post.from.id, :fb_item_id => post.id.to_s, :movie_id => movie.id, :facebook_name => post.from.name, :posted_on => post.created_time.to_date)
            #if facebook_users.has_key?(post.from.id)
              #Activity.log_activity(post, movie, 'posted on wall' ,facebook_users[post.from.id.to_s])
              Activity.create_log_for_each_friend(post, movie, 'posted on wall', post.from.id)
            #end
          end
        rescue
          # this for any errors
        end
      end
    end
  end



end

