class UserMessagesController < ApplicationController
  layout 'website'

  def create
    @user_message = UserMessage.new(params[:user_message])
    if verify_recaptcha(:model => @user_message, :message => 'Please re-enter the words from the image again!') and @user_message.save
      redirect_to(contact_us_path, :notice => 'Thank you')
    else
      @content = Page.find_reference('contact-us').first rescue nil
      render '/home/contact_us'
    end
  end
end

