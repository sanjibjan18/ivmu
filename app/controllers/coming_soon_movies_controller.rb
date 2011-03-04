class ComingSoonMoviesController < ApplicationController
  skip_before_filter :authenticate_user!
  layout 'website'

  def index
    @movies = Movie.comming_soon_movies.paginate(:page => params[:page] || 1, :per_page => 10)
  end

  def show
    @movie = Movie.find_using_id(params[:id]).first
  end

end

