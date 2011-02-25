class UserTokensController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:create]


  def create
    omniauth = request.env["omniauth.auth"]
    user_token = UserToken.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if user_token
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:user, user_token.user)
    elsif current_user
      if current_user.has_user_token?(omniauth['provider'], omniauth['uid'])
        current_user.user_tokens.create!(:provider => omniauth['provider'], :uid => omniauth['uid'], :token => omniauth['credentials']['token'], :secret => omniauth['credentials']['secret'])
         if omniauth['provider'] == "twitter"
           name = omniauth['extra']['user_hash']['screen_name']
           if current_user.user_profile.blank?
              current_user.user_profile.create!(:twitter_screen_name => name, :screen_name => name)
           else
              current_user.user_profile.update_attribute("twitter_screen_name", name)
           end
         end
      end
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

