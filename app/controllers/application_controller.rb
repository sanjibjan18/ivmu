class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  layout :specify_layout

  def specify_layout
    devise_controller? ? "registration" : "application"
  end

  include Facebooker2::Rails::Controller

  def admin?
    redirect_to root_path unless current_user.is_admin == true
  end

end

