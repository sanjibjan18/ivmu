class CommentsController < ApplicationController
 def create
   movie = Movie.find(params[:movie_id])
   movie.comments.create(params[:comment])
   redirect_to root_path
 end
 
 def post_to_wall
    comment = Comment.find(params[:id])
    client = Mogli::Client.new(current_user.oauth2_token)
    @myself  = Mogli::User.find("me",client)
    post = Mogli::Post.new(:message => comment.comment)
    @myself.feed_create(post)
    redirect_to root_path
  end
end
