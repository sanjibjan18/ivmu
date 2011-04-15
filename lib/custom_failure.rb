class CustomFailure < Devise::FailureApp
def redirect_url
      request_format = request.format.to_sym
      if request_format == :html
        send(:"new_#{scope}_session_path")
      else
        send(:"user_session_path", :format => request_format)
      end
    end

 def http_auth?
      if request.xhr?
        Devise.http_authenticatable_on_xhr
      else
        !(request.format && Devise.navigational_formats.include?
(request.format.to_sym))
      end
    end

 def respond
      if http_auth?
        http_auth
      elsif warden_options[:recall]
        recall
      else
        redirect
      end
    end
end

