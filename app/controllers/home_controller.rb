class HomeController < ApplicationController
  skip_before_filter :authenticate_user!
  layout 'website'
  
  def index
    @movies = Movie.latest.limit(6)
  end
  
  def fetch
    current_user.fetch_fb_feeds
  end
end
