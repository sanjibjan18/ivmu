class ComingSoonMoviesController < ApplicationController
  layout 'website'

  def index
    @movies = Movie.comming_soon_movies
  end

  def show
    @movie = Movie.find(params[:id])
  end

end

