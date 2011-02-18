class RecommendationMail < ActionMailer::Base
  default  :from =>  %{"muvi user" <information@muvi.in>}, :reply_to => 'information@muvi.in', :content_type => "text/html"
  
  def send_recommendation(email_ids, subj, content)  
    @content = content
    mail(:to => email_ids, :subject => subj)  
  end 
end
