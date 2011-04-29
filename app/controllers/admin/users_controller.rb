class Admin::UsersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin?
  layout 'admin'

  def index
    @users = User.all_without_admin
  end


  def delete_users
    #User.where('id in (?)', params[:user_ids]).destroy_all unless params[:user_ids].blank?
    unless params[:user_ids].blank?
      User.where('id in (?)', params[:user_ids]).each do |user|
        user.destroy
      end
    end
    redirect_to admin_users_path
  end

end

