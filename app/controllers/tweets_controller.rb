class TweetsController < ApplicationController
  skip_before_filter :authenticate_user!
  layout 'website'

  def index
    @movie ||= Movie.find(params[:id])
    @tweet_search = Tweet.search({:movie_id_eq => @movie.id, :meta_sort => "tweeted_on.desc"})
    @movie_tweets = @tweet_search.all.paginate(:page => params[:page], :per_page => 4)
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  def for_user
    @movie_tweets = Tweet.latest.where(:twitter_screen_name => params[:twitter_name]).paginate(:page => params[:page], :per_page => 12)
  end
end

