class Tweet < ActiveRecord::Base
  belongs_to :user
  belongs_to :movie


  def self.fetch_tweets #(user)
    last_tweet = Tweet.last
    search = Twitter::Search.new
    Movie.name_is_not_blank.latest.limit(6).each do |movie|
      if last_tweet.blank?
        Tweet.tweet_pagination(search.containing("#{movie.name}").per_page(100), movie)
      else
        Tweet.tweet_pagination(search.containing("#{movie.name}").since_date("#{last_tweet.created_at.to_date.to_s}").per_page(100), movie)
      end
      search.clear
    end # all movies end
  end # def end

  def self.fetch_tweets_for_films #(user)
    search = Twitter::Search.new
    movies = []
    ["Dabangg", "No One Killed Jessica"].each do |movie_name|
      movies << Movie.find_by_name(movie_name)
    end
    movies.compact!

    movies.each do |movie|
        last_tweet = movie.tweets.last rescue nil
        if last_tweet.blank?
          Tweet.tweet_pagination(search.containing("#{movie.name}").per_page(100), movie)
        else
          Tweet.tweet_pagination(search.containing("#{movie.name}").since_date("#{last_tweet.created_at.to_date.to_s}").per_page(100), movie)
        end
        search.clear

    end # all movies end


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
                  self.facebook_friends_posts.create(:feed_type => 'friends_post', :value => post.message, :fbid => friend.id, :fb_item_id => post.id, :movie_id => movie.id)
                end
              end # movie end
            end # unless post message blank
          end # each post end

        end
      end



    end



  end # def end



  def self.tweet_pagination(search, movie)
    search.each do |tweet|
      Tweet.create_tweet(tweet, movie)
    end
    if search.next_page?
      search.fetch_next_page
      Tweet.tweet_pagination(search, movie)
    else
      search.fetch_next_page
      search.each do |tweet|
        Tweet.create_tweet(tweet, movie)
      end
    end
  end


  def self.create_tweet(tweet, movie)
    movie_tweet = { :content => tweet.text, :twitter_id => tweet.from_user_id, :tweeted_on => tweet.created_at }
    user_profile = UserProfile.find_by_twitter_screen_name(tweet.from_user)
    if user_profile
      movie_tweet[:user_id] = user_profile.user_id
    end

    if (!movie.release_date.blank? && movie.release_date.to_date <= tweet.created_at.to_date)
      movie_tweet[:review] = true
    end


    movie.tweets.create(movie_tweet)
  end

end

