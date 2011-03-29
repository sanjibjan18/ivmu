class HomeController < ApplicationController
  skip_before_filter :authenticate_user!
  layout 'website'

  def index
    @movies = Movie.latest.released.paginate(:page => params[:page], :per_page => 6)
  end

  def fetch
    current_user.delay.fetch_fb_feeds
    FacebookFeed.delay.fetch_posts_for_films(current_user) if current_user
    redirect_to root_path
  end

  def fetch_tweets
    Tweet.fetch_tweets #(current_user) if current_user
    redirect_to root_path
  end

  def page
    begin
      @page = Page.where('permalink = ?', params[:id]).first
    rescue
      logger.debug "*** RecordNotFound with id = #{params[:id]} ***"
      render_404
    end
   end

end

