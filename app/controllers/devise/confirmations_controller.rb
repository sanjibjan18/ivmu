class Devise::ConfirmationsController < ApplicationController
  include Devise::Controllers::InternalHelpers

  # GET /resource/confirmation/new
  def new
    build_resource({})
    #render_with_scope :new
    render :layout => false
  end

  # POST /resource/confirmation
  def create
    self.resource = resource_class.send_confirmation_instructions(params[resource_name])

    if resource.errors.empty?
      set_flash_message :notice, :send_instructions
     # redirect_to new_session_path(resource_name)
    else
      render_with_scope :new
    end
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    puts "pppppppppppppppppp #{resource.inspect}"
    if resource.errors.empty?
      set_flash_message :notice, :confirmed
      WelcomeMailer.send_welcome_mail(resource).deliver
      sign_in_and_redirect(resource_name, resource)
    else
      render_with_scope :new
    end
  end
end

