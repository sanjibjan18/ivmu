class CommentsController < ApplicationController
  before_filter :find_movie, :only => [:create, :index]
  skip_before_filter :authenticate_user! , :only => [:index]
  layout 'website'
  def index
    respond_to do |format|
      format.html { }
      format.js {

      }
    end
  end


  def create
    @comment = @movie.comments.new(params[:comment].merge({:user_id => current_user.id}))
    @comment.save
    respond_to do |format|
      format.html { redirect_to movie_path(movie) }
      format.js { }
    end
  end

  private
  def find_movie
    @movie = Movie.find_using_id(params[:movie_id]).first
  end

end

