class Review < ActiveRecord::Base
  MAX_RATING = 5
  belongs_to :movie
  belongs_to :user

  after_create :log_activity
  after_save :post_to_wall
  after_save :post_to_twitter

  def post_to_wall
    unless self.user.facebook_omniauth.blank?
      if self.facebook
        begin
          client = Mogli::Client.new(self.user.facebook_token)
          @myself  = Mogli::User.find("me", client)
          post = Mogli::Post.new({:message => self.description, :name => "#{self.user.display_name} rated #{self.movie.name} #{self.rating} starts",:link => "http://ec2-122-248-194-131.ap-southeast-1.compute.amazonaws.com/movies/#{self.movie.permalink}",:caption => '&nbsp;', :description => '&nbsp;', :picture => "http://ec2-122-248-194-131.ap-southeast-1.compute.amazonaws.com/"+ self.movie.banner_image.to_s, :actions => {"name" =>  "See Muvi.in Review", "link" => "http://ec2-122-248-194-131.ap-southeast-1.compute.amazonaws.com/movies/#{self.movie.permalink}"} })
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
          self.user.twitter.update("#{self.description}")
        rescue Twitter::Unauthorized
        end
      end
    end
  end

  def log_activity
    Activity.log_activity(self, self.movie, 'rated',  self.user_id)
  end

  scope :for_movie, lambda{|movie| where(:movie_id => movie.id)}


  def link_detail
    detail = {}
    detail[:name] =  "#{self.user.display_name} rated #{self.movie.name} #{self.rating} starts",
    detail[:link] = "http://ec2-122-248-194-131.ap-southeast-1.compute.amazonaws.com/movies/#{self.movie.permalink}"
    detail[:description] = ''
    detail

  end
end

