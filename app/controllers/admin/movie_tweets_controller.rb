class Admin::MovieTweetsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin?
  before_filter :find_movie
  layout 'admin'

  def index
  end

  def show
    @tweet = @movie.tweets.find(params[:id])
  end

  def destroy
    @movie.tweets.find(params[:id]).destroy
    redirect_to admin_movie_movie_tweets_path(@movie)
  end


  private
  def find_movie
    @movie = Movie.find_using_id(params[:movie_id]).includes([:tweets]).first
  end

end

