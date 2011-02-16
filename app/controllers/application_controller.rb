class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  
  include Facebooker2::Rails::Controller
end
