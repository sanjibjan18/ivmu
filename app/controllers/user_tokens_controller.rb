class UserTokensController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:create]


  def create
    omniauth = request.env["omniauth.auth"]
    user_token = UserToken.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if user_token
      user_token.update_token_and_secret(omniauth)
      user_token.user.update_user_profile(omniauth) # update or create user profile
      FacebookFeed.delay.fetch_posts_for_films
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:user, user_token.user)
    elsif current_user
       current_user.create_user_tokens(omniauth) if current_user.has_user_token?(omniauth['provider'], omniauth['uid'])
       # create a user token
      flash[:notice] = "Authentication successful."
      redirect_to root_url
    else
      user = User.new
      user.create_user_from_omniauth(omniauth)
      if user.save(false)
        flash[:notice] = "Signed in successfully."
        sign_in_and_redirect(:user, user)
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
    redirect_to edit_user_profile_path(current_user)
  end

end

