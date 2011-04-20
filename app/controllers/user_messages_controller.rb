class UserMessagesController < ApplicationController
  layout 'website'
  skip_before_filter :authenticate_user!
  def create
    @user_message = UserMessage.new(params[:user_message])
    if @user_message.save
      redirect_to(contact_us_path, :notice => 'Thank you')
    else
      render '/home/contact_us'
    end
  end
end

