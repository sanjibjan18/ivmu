class MoviesController < ApplicationController
  skip_before_filter :authenticate_user!
  layout 'website'

  def index
    @search = Movie.latest.search(params[:search])
    @movies = @search.all.paginate(:page => params[:page], :per_page => 10)
    if @movies.size == 1
      redirect_to movie_path(@movies.first) and return
    end
  end

  def show
    @movie = Movie.find_using_id(params[:id]).includes([:comments, :critics_reviews]).first
    @critics_reviews = @movie.critics_reviews.latest.paginate(:page => 1, :per_page => 2)
    @movie_tweets = @movie.tweets.latest.paginate(:page => 1, :per_page => 4)
    @facebook_posts = @movie.facebook_posts.paginate(:page => 1, :per_page => 4)
  end
end

