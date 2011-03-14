class HomeController < ApplicationController
  skip_before_filter :authenticate_user!
  layout 'website'

  def index
    @movies = Movie.latest.page(params[:page]).per(2)
    #puts "pppppppppp #{@movies.inspect}"
  end

  def fetch
    current_user.delay.fetch_fb_feeds
    FacebookFeed.delay.fetch_posts_for_films
    redirect_to root_path
  end

  def fetch_tweets
    Tweet.fetch_tweets #(current_user) if current_user
    redirect_to root_path
  end

end

