class ComingSoonMoviesController < ApplicationController
  skip_before_filter :authenticate_user!
  layout 'website'

  def index
    @movies = Movie.comming_soon_movies.paginate(:page => params[:page] || 1, :per_page => 6)
  end

  def show
    @movie = Movie.find_using_id(params[:id]).first
    @critics_review_search = @movie.critics_reviews.search({:meta_sort => "review_date.desc"})
    #@critics_reviews = @critics_review_search.all.paginate(:per_page => 2)
    @critics_reviews = @movie.critics_reviews.order('review_date desc').paginate(:page => params[:page], :per_page => 2)
    @tweet_search = Tweet.search({:movie_id_eq => @movie.id, :meta_sort => "tweeted_on.desc"})
    @movie_tweets = @tweet_search.all.paginate(:per_page => 4)
  end

end

