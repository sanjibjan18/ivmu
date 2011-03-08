class CriticsReviewsController < ApplicationController
    skip_before_filter :authenticate_user!
  layout 'website'
  def show
    @critics_review = CriticsReview.find(params[:id])
  end

end

