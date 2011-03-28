class UsersController < ApplicationController
  skip_before_filter :authenticate_user!
  layout 'website'

  def show
  end



end

