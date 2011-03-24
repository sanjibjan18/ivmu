class RegistrationsController < Devise::RegistrationsController

  def new
    super
  end

  def create
    build_resource
    if resource.save
      puts "eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"
      if resource.active?
        puts "tttttttttttttttttttttttttttttttttttt"
        #redirect_to edit_member_path(resource)
      else
        puts "ooooooooooooooooooooooooooooooooo"
        #set_flash_message :notice, :inactive_signed_up, :reason => resource.inactive_message.to_s
        expire_session_data_after_sign_in!
        #redirect_to after_inactive_sign_up_path_for(resource)
      end
    else
      puts "zzzzzzzzzzzzzzzzzzzzzzzzzzzz"
      clean_up_passwords(resource)
      render_with_scope :new
    end
  end

  def edit
    super
  end

  def update
    super
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

