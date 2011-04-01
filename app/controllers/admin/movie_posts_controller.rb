class Admin::MoviePostsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin?
  before_filter :find_movie
  layout 'admin'

  def index
    @facebook_feeds = @movie.facebook_feeds.all_posts.paginate(:page => params[:page], :per_page => 50)
  end

  def show
    @post = @movie.facebook_feeds.find(params[:id])
  end

  def edit
    @post = @movie.facebook_feeds.find(params[:id])
  end


  def update
    @post = @movie.facebook_feeds.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:facebook_feed])
        format.html { redirect_to(admin_movie_movie_post_path(@movie, @post), :notice => 'Facebook Post was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end
  def destroy
    @movie.facebook_feeds.find(params[:id]).destroy
    redirect_to admin_movie_movie_posts_path(@movie)
  end


  private
  def find_movie
    @movie = Movie.find_using_id(params[:movie_id]).includes([:facebook_feeds]).first
  end
end

