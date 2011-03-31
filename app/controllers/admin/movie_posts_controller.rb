class Admin::MoviePostsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin?
  before_filter :find_movie
  layout 'admin'

  def index
    @facebook_feeds = @movie.facebook_feeds.all_posts
  end

  def show
    @post = @movie.facebook_feeds.find(params[:id])
  end

  def destroy
    @movie.facebook_feeds.find(params[:id]).destroy
    redirect_to admin_movie_movie_posts_path(@movie)
  end


  private
  def find_movie
    @movie = Movie.find_using_id(params[:movie_id]).includes([:facebook_feeds]).first
  end
end

