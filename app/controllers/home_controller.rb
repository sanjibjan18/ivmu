class HomeController < ApplicationController
  skip_before_filter :authenticate_user!
  layout 'website'

  def index
    @movies = Movie.latest.paginate(:page => params[:page] || 1, :per_page => 6)
  end

  def fetch
    current_user.fetch_fb_feeds
    redirect_to root_path
  end

  def fetch_tweets
    Tweet.fetch_tweets #(current_user) if current_user
    redirect_to root_path
  end

end

