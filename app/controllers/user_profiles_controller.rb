class UserProfilesController < ApplicationController
  layout 'website'
  def edit
    @user_profile = current_user.user_profile || UserProfile.new
  end


  def create
    @user_profile = current_user.build_user_profile(params[:user_profile])
    respond_to do |format|
      if @user_profile.save
        format.html { redirect_to(edit_user_profile_path(@user_profile) , :notice => 'user_profile was successfully created.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user_profile.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @user_profile = current_user.user_profile rescue current_user.build_user_profile

    respond_to do |format|
      if @user_profile.update_attributes(params[:user_profile])
        format.html { redirect_to(edit_user_profile_path(@user_profile) , :notice => 'user_profile was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user_profile.errors, :status => :unprocessable_entity }
      end
    end
  end

end

