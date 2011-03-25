class CastsController < ApplicationController
  skip_before_filter :authenticate_user!
  layout 'website'

  def index
    @casts = Cast.paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @cast = Cast.find(params[:id])
  end

end

