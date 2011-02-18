class RecommendationsController < ApplicationController
  def create
    movie = Movie.find(params[:movie_id])
    movie.recommendations.create(params[:recommendation].merge({:user_id => current_user.id}))
    redirect_to root_path
  end
end
