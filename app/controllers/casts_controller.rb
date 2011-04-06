class CastsController < ApplicationController
  skip_before_filter :authenticate_user!
  layout 'website'

  def index
    @casts = Celebrity.paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @cast = Celebrity.find(params[:id])
  end

end

