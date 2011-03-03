class MoviesController < ApplicationController
  skip_before_filter :authenticate_user!
  layout 'website'
  def show
    @movie = Movie.find_using_id(params[:id]).first
  end
end

