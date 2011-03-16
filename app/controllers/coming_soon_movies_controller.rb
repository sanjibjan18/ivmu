class ComingSoonMoviesController < ApplicationController
  skip_before_filter :authenticate_user!
  layout 'website'

  def index
    @movies = Movie.comming_soon_movies.paginate(:page => params[:page] || 1, :per_page => 6)
  end

  def show
    @movie = Movie.find_using_id(params[:id]).first
    @movie_tweets = @movie.tweets.latest.paginate(:page => 1, :per_page => 4)
    @facebook_posts = @movie.facebook_feeds.posts.latest.paginate(:page => 1, :per_page => 4)
  end

end

