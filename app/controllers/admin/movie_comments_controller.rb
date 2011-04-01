class Admin::MovieCommentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin?
  before_filter :find_movie
  layout 'admin'

  def index
    @comments = @movie.comments.paginate(:page => params[:page], :per_page => 50)
  end

  def show
    @comment = @movie.comments.find(params[:id])
  end

  def destroy
    @movie.comments.find(params[:id]).destroy
    redirect_to admin_movie_movie_comments_path(@movie)
  end


  private
  def find_movie
    @movie = Movie.find_using_id(params[:movie_id]).includes([:comments]).first
  end
end

