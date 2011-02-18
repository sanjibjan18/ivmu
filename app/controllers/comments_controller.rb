class CommentsController < ApplicationController
  def create
    movie = Movie.find(params[:movie_id])
    movie.comments.create(params[:comment].merge({:user_id => current_user.id}))
    redirect_to root_path
  end
end
