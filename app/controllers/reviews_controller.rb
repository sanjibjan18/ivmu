class ReviewsController < ApplicationController
  def create
    movie = Movie.find(params[:movie_id])
    movie.reviews.create(params[:review].merge(:user_id => current_user.id))
    redirect_to root_path
  end
end
