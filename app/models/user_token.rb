class UserToken < ActiveRecord::Base
  belongs_to :user
  after_create :pull_data_from_facebook
  after_create :pull_data_from_twitter



  def pull_data_from_facebook
    self.user.delay.fetch_fb_feeds
  end

  def pull_data_from_twitter
    if self.provider == 'twitter'
      self.user.fetch_friends_from_twitter
    end
  end

  def update_token_and_secret(omniauth)
    self.token = (omniauth['credentials']['token'] rescue nil)
    self.secret = (omniauth['credentials']['secret'] rescue nil)
    self.save!
  end

end

