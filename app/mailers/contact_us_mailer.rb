class ContactUsMailer < ActionMailer::Base
  default  :from =>  %{"muvi user" <info@muvi.in>},  :content_type => "text/html"

  def send_contact_us(object)
    @object = object
    mail(:to => 'info@muvi.in', :reply_to => @object.email, :subject => 'Message from muvi.in user')
  end
end

