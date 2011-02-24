class UserTokensController < ApplicationController
  skip_before_filter :authenticate_user!


  def create
    omniauth = request.env["omniauth.auth"]
    user_token = UserToken.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if user_token
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:user, user_token.user)
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



end

