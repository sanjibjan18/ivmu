class FbTestsController < ApplicationController
  def index
    #This is just for demonstration purpose only. To be removed at latter stage. 
    #client = Mogli::Client.new(current_user.oauth2_token)
    #@myself  = Mogli::User.find("me",client)
    #Mogli::Post.new(:message => "This is a test message at #{Time.now} from FacebookGraphTestController to a page")
    #client.post("#...@page.id}/feed", nil, post) 
    #@likes = @myself.likes
    #@friends = @myself.friends
 
    #Right now data fetch is done in this method.
    #current_user.fetch_fb_feeds
    @movies = Movie.limit(10).all
  end

end
