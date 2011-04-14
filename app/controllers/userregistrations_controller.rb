class UserregistrationsController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:create, :new]
  layout 'website'

  def new
    omniauth = request.env["omniauth.auth"]
    @user_data = get_data_from_omniauth(omniauth)


    #user_token = UserToken.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    #if user_token
      #user_token.update_token_and_secret(omniauth)
      #user_token.user.update_user_profile(omniauth) # update or create user profile
      #FacebookFeed.delay.fetch_posts_for_films(user_token.user)
      #login_user(user_token.user) # login the user, and check for password is blank
    #elsif current_user
       #current_user.create_user_tokens(omniauth) if current_user.has_user_token?(omniauth['provider'], omniauth['uid'])
       # create a user token
      #flash[:notice] = "Authentication successful."
      #login_user(current_user) # login the user, and check for password is blank
    #else
      #@user = User.new
      #@user.create_user_from_omniauth(omniauth)
    #end
  end


  def create
    @user = User.new(params[:user])
    @user.save
    #flash[:notice] = "Please make sure that, you have confirmed your Muvi.in registration."
    #redirect_to new_user_session_path
  end

  def show
  end


  def login_user(user)
    sign_in(:user, user)
    if user.password_is_blank?
      redirect_to edit_user_registration_path
    else
      sign_in_and_redirect(:user, user)
    end
  end

  def get_data_from_omniauth(omniauth)
    hash = {}
    hash[:email] = (omniauth['extra']['user_hash']['email'] rescue '' )
    hash[:provider] = omniauth['provider']
    hash[:uid] = omniauth['uid']
    hash[:token] = (omniauth['credentials']['token'] rescue nil)
    hash[:secret] = (omniauth['credentials']['secret'] rescue nil)
    hash[:name] = (omniauth['provider'] == 'facebook')? (omniauth['extra']['user_hash']['name'] rescue '') : (omniauth['extra']['user_hash']['screen_name'] rescue '')
    hash
  end

end
