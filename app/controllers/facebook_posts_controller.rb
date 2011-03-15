class FacebookPostsController < ApplicationController
  skip_before_filter :authenticate_user!
  layout 'website'

  def index
    @movie ||= Movie.find(params[:id])
    @facebook_posts = @movie.facebook_posts.paginate(:page => params[:page], :per_page => 4)
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

end

