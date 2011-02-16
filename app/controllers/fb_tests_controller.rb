class FbTestsController < ApplicationController
  def index
    client = Mogli::Client.new(current_user.oauth2_token)
    @myself  = Mogli::User.find("me",client)
    @posts = @myself.posts
  end

end
