class CriticsReviewsController < ApplicationController
  layout 'website'
  def show
    @critics_review = CriticsReview.find(params[:id])
  end

end

