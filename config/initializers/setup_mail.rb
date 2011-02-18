ActionMailer::Base.smtp_settings = {
:address => "smtp.gmail.com", 
:port => 587, 
:domain => "muvi.in", 
:user_name => "admin@muvi.in", 
:password => "", 
:authentication => "plain", 
:enable_starttls_auto => true
}
