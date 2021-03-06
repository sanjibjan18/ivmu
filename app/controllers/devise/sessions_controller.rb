class Devise::SessionsController < ApplicationController
  prepend_before_filter :require_no_authentication, :only => [ :new, :create ]
  include Devise::Controllers::InternalHelpers
  skip_before_filter :authenticate_user!

  # GET /resource/sign_in
  def new
    clean_up_passwords(build_resource)
    #render_with_scope :new
    #render :layout => false
  end

  # POST /resource/sign_in
  def create
    resource = warden.authenticate!(:scope => resource_name, :recall => 'failure')
    set_flash_message :notice, :signed_in
    #sign_in_and_redirect(resource_name, resource)
  end

  # GET /resource/sign_out
  def destroy
    signed_in = signed_in?(resource_name)
    sign_out_and_redirect(resource_name)
    set_flash_message :notice, :signed_out if signed_in
  end

  def failure
  end

end

