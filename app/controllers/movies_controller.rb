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
  end
end

