class ComingSoonMoviesController < ApplicationController
  skip_before_filter :authenticate_user!
  layout 'website'
  #caches_page :index

  def index
    @search = Movie.comming_soon_movies.search
    params[:sort] ||= 'latest_update'
    case params[:sort]
    when 'latest_update'

    when 'user_interest'

    when 'release_date'
    end

    @movies = @search.paginate(:page => params[:page], :per_page => 6)
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  def show
    @movie = Movie.find_using_id(params[:id]).first
    @movie_tweets = @movie.tweets.latest.paginate(:page => 1, :per_page => 4)
    @facebook_posts = @movie.facebook_feeds.posts.friends_ids(current_user.facebook_friends_ids).latest.paginate(:page => params[:page], :per_page => 4) if current_user && current_user.facebook_omniauth
  end

end

