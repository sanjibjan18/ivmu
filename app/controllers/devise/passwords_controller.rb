class Devise::PasswordsController < ApplicationController
  prepend_before_filter :require_no_authentication
  include Devise::Controllers::InternalHelpers
  layout 'website', :only => [:edit]
  # GET /resource/password/new
  def new
    build_resource({})
  end

  # POST /resource/password
  def create
    self.resource = resource_class.send_reset_password_instructions(params[resource_name])
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    self.resource = resource_class.new
    resource.reset_password_token = params[:reset_password_token]
    render_with_scope :edit
  end

  # PUT /resource/password
  def update
    params[:user][:password_confirmation] = params[:user][:password]
    self.resource = resource_class.reset_password_by_token(params[resource_name])
    clean_up_passwords(build_resource) if resource.errors.empty?
  end
end

