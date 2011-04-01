class Admin::MovieTweetsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin?
  before_filter :find_movie
  layout 'admin'

  def index
   @tweets =  @movie.tweets.paginate(:page => params[:page], :per_page => 50)
  end

  def show
    @tweet = @movie.tweets.find(params[:id])
  end

  def edit
    @tweet = @movie.tweets.find(params[:id])
  end


  def update
    @tweet = @movie.tweets.find(params[:id])

    respond_to do |format|
      if @tweet.update_attributes(params[:tweet])
        format.html { redirect_to(admin_movie_movie_tweet_path(@movie, @tweet), :notice => 'tweet was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @tweet.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @movie.tweets.find(params[:id]).destroy
    redirect_to admin_movie_movie_tweets_path(@movie)
  end



  private
  def find_movie
    @movie = Movie.find_using_id(params[:movie_id]).includes([:tweets]).first
  end

end

