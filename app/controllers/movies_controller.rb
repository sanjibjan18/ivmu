class MoviesController < ApplicationController
 skip_before_filter :authenticate_user!
  layout 'website'

  def index
    @search = Movie.latest.search(params[:search])
    @movies = @search.paginate(:page => params[:page], :per_page => 10)
    if @movies.size == 1
      redirect_to movie_path(@movies.first) and return
    end
  end

  def show
    @movie = Movie.find_using_id(params[:id]).includes([:comments, :critics_reviews, :tweets, :facebook_feeds, :movie_casts]).first
    @critics_reviews = @movie.critics_reviews.latest.paginate(:page => params[:page], :per_page => 4)
    #@movie_tweets = @movie.tweets.reviews.latest.paginate(:page => params[:page], :per_page => 4)
    @facebook_posts = @movie.facebook_feeds.posts.friends_ids(current_user.facebook_friends_ids).latest.paginate(:page => params[:page], :per_page => 4) if current_user && current_user.facebook_omniauth
    #TODO try improving this
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


  def autocomplete
    movie_names = Movie.search(:name_contains => params[:term]).paginate(:page => 1, :per_page => 10).collect(&:name)
    render :json => movie_names.to_json
  end

end

