class TweetsController < ApplicationController
  skip_before_filter :authenticate_user!
  layout 'website'

  def index
    @movie ||= Movie.find(params[:id])
    #@tweet_search = Tweet.search({:movie_id_eq => @movie.id, :meta_sort => "tweeted_on.desc"})
    #@movie_tweets = @tweet_search.all.paginate(:page => params[:page], :per_page => 4)
    my_query = "((select 'movie_review' as model,user_id,description,rating,'' as review,'' as twitter_name,created_at from reviews where reviews.movie_id=#{@movie.id} ) UNION (select 'movie_tweet' as model,user_id,content,rating,review,twitter_screen_name,tweeted_on from tweets WHERE ( tweets.interest = 'f') AND (tweets.review = 'pos' or tweets.review = 'neg' ) AND (tweets.movie_id = #{@movie.id}) ) order by twitter_name asc) as temp"
    total_entries = ActiveRecord::Base.connection.execute("select count(*) as count from #{my_query}").first['count'].to_i
    result = ActiveRecord::Base.connection.select_rows("select * from #{my_query}")
    @movie_tweets =  result.paginate(:page => params[:page], :per_page =>  4)

    respond_to do |format|
      format.html { render :layout => false}
      format.js {}
    end
  end

  def for_user
    @movie_tweets = Tweet.latest.where(:twitter_screen_name => params[:twitter_name]).paginate(:page => params[:page], :per_page => 12)
  end
end

