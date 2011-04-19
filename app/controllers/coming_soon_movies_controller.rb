class ComingSoonMoviesController < ApplicationController
  skip_before_filter :authenticate_user!
  layout 'website'
  #caches_page :index

  def index
    @search = Movie.comming_soon_movies.search(params[:search])
    params[:sort] ||= 'latest_update'
    case params[:sort]
    when 'latest_update'
      @search = @search.relation.sort_by_poster_and_trailer_desc
    when 'user_interest'
      @search = @search.relation.sort_by_user_interest_desc
    when 'release_date'
      @search = @search.relation.sort_by_release_date_asc
    end

    @movies = @search.paginate(:page => params[:page], :per_page => 6)
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  def show
    @movie = Movie.find_using_id(params[:id]).first
    #@movie_tweets = @movie.tweets.latest.paginate(:page => 1, :per_page => 4)
   # @facebook_posts = @movie.facebook_feeds.posts.friends_ids(current_user.facebook_friends_ids).latest.paginate(:page => params[:page], :per_page => 4) if current_user && current_user.facebook_omniauth
    @actors = []
    @movie.movie_casts.each do |cast|
      case cast.cast_type
      when 'actor' then @actors << cast
      when 'director' then @director = cast
      when 'producer' then @producer = cast
      when 'writer' then @writer = cast
      when 'musics' then @music = cast
      end
    end
  end

end

