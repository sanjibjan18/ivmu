class CriticsReviewsController < ApplicationController
  skip_before_filter :authenticate_user!
  layout 'website'

  def index
    @movie ||= Movie.find(params[:id])
    sort = params[:sort] || 'review_date'
    @critics_review_search = CriticsReview.search({:movie_id_eq => @movie.id, :meta_sort => "#{sort}.desc"})
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

