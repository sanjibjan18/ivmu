class FacebookPostsController < ApplicationController
  skip_before_filter :authenticate_user!
  layout 'website'
  caches_page :index

  def index
    @movie ||= Movie.find(params[:id])
    @facebook_posts = if current_user && current_user.facebook_omniauth
      @movie.facebook_feeds.posts.friends_ids(current_user.facebook_friends_ids).latest.paginate(:page => params[:page], :per_page => 4)
    else
       []
    end
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

end

