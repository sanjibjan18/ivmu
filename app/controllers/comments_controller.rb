class CommentsController < ApplicationController
  def create
    movie = Movie.find_using_id(params[:movie_id]).first
    movie.comments.create(params[:comment].merge({:user_id => current_user.id}))
    redirect_to movie_path(movie)
  end
end

