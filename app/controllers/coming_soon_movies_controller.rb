class ComingSoonMoviesController < ApplicationController
  skip_before_filter :authenticate_user!
  layout 'website'

  def index
    @movies = Movie.comming_soon_movies
  end

  def show
    @movie = Movie.find(params[:id])
  end

end

