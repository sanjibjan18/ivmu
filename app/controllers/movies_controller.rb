class MoviesController < ApplicationController
  skip_before_filter :authenticate_user!
  layout 'website'

  def index
    @search = Movie.search(params[:search])
    @movies = @search.all.paginate(:page => params[:page] || 1, :per_page => 10)
  end

  def show
    @movie = Movie.find_using_id(params[:id]).includes(:comments).first
  end
end

