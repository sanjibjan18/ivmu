ActionMailer::Base.smtp_settings = {
:address => "smtp.gmail.com", 
:port => 587, 
:domain => "exelanz.com", 
:user_name => "muvi.in@exelanz.com", 
:password => "password", 
:authentication => "plain", 
:enable_starttls_auto => true 
}
