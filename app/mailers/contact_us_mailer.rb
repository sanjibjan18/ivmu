class ContactUsMailer < ActionMailer::Base
  default  :from =>  %{"muvi user" <information@muvi.in>},  :content_type => "text/html"

  def send_contact_us(object)
    @object = object
    mail(:to => 'info@muvi.in',:reply_to => @object.email, :subject => 'Contact from website')
  end
end
