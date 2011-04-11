class RegistrationsController < Devise::RegistrationsController
  layout 'website'

  def new
    build_resource({})
    #render_with_scope :new
    render :layout => false
  end

  def create
    build_resource
    if resource.save
      if resource.active?
        #redirect_to edit_member_path(resource)
      else
        #set_flash_message :notice, :inactive_signed_up, :reason => resource.inactive_message.to_s
        expire_session_data_after_sign_in!
        #redirect_to after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords(resource)
      render_with_scope :new
    end
  end

  def edit
    super
  end

  def update
    # Devise use update_with_password instead of update_attributes.
    # This is the only change we make.
    if resource.update_attributes(params[resource_name])
      set_flash_message :notice, :updated
      # Line below required if using Devise >= 1.2.0
      #sign_in resource_name, resource, :bypass => true
      redirect_to after_update_path_for(resource)
    else
      clean_up_passwords(resource)
      render_with_scope :edit
    end
  end


  def destroy
    super
  end

  def cancel
    super
  end

  def welcome
  end

      def expire_session_data_after_sign_in!
        session.keys.grep(/^devise\./).each { |k| session.delete(k) }
      end

end

