class UserTokensController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:create]

  def create
    omniauth = request.env["omniauth.auth"]
    user_token = UserToken.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if user_token
      user_token.update_token_and_secret(omniauth)
      user_token.user.update_user_profile(omniauth) # update or create user profile
      flash[:notice] = "Signed in successfully."
      login_user(user_token.user) # login the user, and check for password is blank
    elsif current_user
       current_user.create_user_tokens(omniauth) if current_user.has_user_token?(omniauth['provider'], omniauth['uid'])
       # create a user token
      flash[:notice] = "Authentication successful."
      login_user(current_user) # login the user, and check for password is blank
    else
      user = User.new
      user.create_user_from_omniauth(omniauth)
      if user.save(false)
        user.update_user_profile(omniauth)
        flash[:notice] = "Signed in successfully."
        login_user(user) # login the user, and check for password is blank
      else
        session[:omniauth] = omniauth.except('extra')
        redirect_to new_user_registration_url
      end
    end
  end

  def destroy
    user_token = current_user.user_tokens.find(params[:id])
    user_token.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to edit_user_registration_path
  end

  def login_user(user)
    sign_in(:user, user)
    if user.password_is_blank?
      redirect_to edit_user_registration_path
    else
      sign_in_and_redirect(:user, user)
    end
  end

end

