class Review < ActiveRecord::Base
  MAX_RATING = 5
  belongs_to :movie, :counter_cache => true
  belongs_to :user

  after_create :log_activity
  after_save :post_to_wall
  after_save :post_to_twitter
  scope :for_movie, lambda{|movie| where(:movie_id => movie.id)}

  def post_to_wall
    if self.facebook
      unless self.user.facebook_omniauth.blank?
        begin
          client = Mogli::Client.new(self.user.facebook_token)
          @myself  = Mogli::User.find("me", client)
          post = Mogli::Post.new({:message => self.description, :name => "#{self.user.display_name} rated #{self.movie.name} #{self.rating} starts",:link => "#{SITE_URL}/movies/#{self.movie.permalink}",:caption => '&nbsp;', :description => "RELEASE DATE: #{self.movie_release_date}", :picture => "#{SITE_URL}/#{self.movie.poster.path(:medium)}", :actions => {"name" =>  "See Muvi.in Review", "link" => "#{SITE_URL}/movies/#{self.movie.permalink}"} })
          @myself.feed_create(post)
        rescue Mogli::Client::OAuthException
          # getting this strange exception. (#506) Duplicate status message
          #TODO handle this exception
        end
      end
    end
  end

  def post_to_twitter
    unless self.user.twitter_omniauth.blank?
      if self.twitter
        begin
          self.user.twitter.update("#{self.user.display_name} rated #{self.movie.name} #{self.rating} starts. #{self.description}, #{SITE_URL}/movies/#{self.movie.permalink}")
        rescue Twitter::Unauthorized
        end
      end
    end
  end

  def log_activity
    #Activity.log_activity(self, self.movie, 'rated',  self.user_id)
    if self.facebook && self.user.facebook_omniauth
      Activity.create_log_for_each_friend(self, self.movie, 'rated' , self.user.facebook_omniauth.uid, self.user.display_name)
    end
  end

  def movie_release_date
    Time.parse(self.movie.release_date.to_s).strftime('%b %d, %Y').to_s rescue ''
  end



end

