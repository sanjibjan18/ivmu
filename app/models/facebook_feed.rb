class FacebookFeed < ActiveRecord::Base
  belongs_to :user

  scope :like_name, lambda{|name| where("value like ? ", "#{name}%") }
  scope :by_fb_item_id, lambda{|item_id| where(:fb_item_id => item_id) }
  scope :posts, lambda{ where(:feed_type => 'friends_post') }
  scope :latest, lambda{ order('created_at desc') }

  def self.fetch_posts_for_films
    movies = []
    ["Dabangg", "No One Killed Jessica"].each do |movie_name|
      movies << Movie.find_by_name(movie_name)
    end
    movies.compact!

    UserToken.where('provider = ?','facebook').each do |user_token|
      user = user_token.user
      client = Mogli::Client.new(user_token.token)
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
          user.facebook_feeds.create(:feed_type => 'likes', :value => like.name, :fbid => user.facebook_omniauth.uid, :fb_item_id => like.id) unless user.facebook_feeds.where(:fb_item_id => like.id).exists?
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
                  user.facebook_feeds.create(:feed_type => 'friend_likes', :value => friend_like.name, :fbid => friend.id, :fb_item_id => friend_like.id)
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
                    user.facebook_friends_posts.create(:feed_type => 'friends_post', :value => post.message, :fbid => friend.id, :fb_item_id => post.id, :movie_id => movie.id, :facebook_name => friend.name, :posted_on => post.created_time.to_date)
                  end
                end
              end # movie end
            end # unless post message blank
          end # each post end

        end
      end
    end



  end

end

