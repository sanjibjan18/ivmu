class FbTestsController < ApplicationController
  def index
    #This is just for demonstration purpose only. To be removed at latter stage. 
    #client = Mogli::Client.new(current_user.oauth2_token)
    #@myself  = Mogli::User.find("me",client)
    
    #@likes = @myself.likes
    #@friends = @myself.friends
 
    #Right now data fetch is done in this method.
    #current_user.fetch_fb_feeds
    @movies = Movie.limit(10)
  end

end
