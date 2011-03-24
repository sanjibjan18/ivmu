class CastsController < ApplicationController
  skip_before_filter :authenticate_user!
  layout 'website'

  def index
  end

  def show
    @cast = Cast.find(params[:id])
  end

end

