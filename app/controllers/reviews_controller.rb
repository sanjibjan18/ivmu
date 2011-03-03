class ReviewsController < ApplicationController
  def create
    @movie = Movie.find_using_id(params[:movie_id]).first
    @movie.reviews.create(params[:review].merge(:user_id => current_user.id))
    respond_to do |format|
      format.html  {redirect_to root_path}
      format.js
    end
  end
end

