class WelcomeMailer < ActionMailer::Base
  default  :from =>  %{Muvi.in(info@muvi.in)},  :content_type => "text/html"

  def send_welcome_mail(user)
    @user = user
    mail(:to => user.email, :subject => "Welcome to Muvi.in, #{user.display_name}!")
  end
end

