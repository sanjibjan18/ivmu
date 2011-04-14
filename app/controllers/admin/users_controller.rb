class Admin::UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin?
  layout 'admin'

  def index
    @users = User.all_without_admin
  end


  def delete_users
    redirect_to admin_users_path
  end

end

