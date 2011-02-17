class CommentsController < ApplicationController
 def create
   movie = Movie.find(params[:movie_id])
   movie.comments.create(params[:comment])
   redirect_to root_path
 end
end
