class CommentsController < ApplicationController
 def create
   movie = Movie.find(params[:movie_id])
   movie.comments.create(params[:comment])
 end
end
