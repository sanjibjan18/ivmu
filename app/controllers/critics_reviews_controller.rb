class CriticsReviewsController < ApplicationController
  skip_before_filter :authenticate_user!
  layout 'website'
  caches_page :index
  def index
    @movie ||= Movie.find(params[:id])
    sort = params[:sort] || 'review_date'
    @critics_review_search = CriticsReview.search({:movie_name_eq => @movie.name, :meta_sort => "#{sort}.desc"})
    @critics_reviews = @critics_review_search.all.paginate(:page => params[:page], :per_page => 2)
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  def show
    @critics_review = CriticsReview.find(params[:id])
  end

end

