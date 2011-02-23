class ReviewsController < ApplicationController
  def create
    @movie = Movie.find(params[:movie_id])
    @movie.reviews.create(params[:review].merge(:user_id => current_user.id))
    respond_to do |format|
      format.html  {redirect_to root_path}
      format.js
    end

  end
end

