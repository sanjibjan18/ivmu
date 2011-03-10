class UserToken < ActiveRecord::Base
  belongs_to :user
  after_create :pull_data_from_facebook
  after_create :pull_data_from_twitter


  def pull_data_from_facebook
    self.user.delay.fetch_fb_feeds if self.provider == 'facebook'
  end

  def pull_data_from_twitter
    Tweet.delay.fetch_tweets if self.provider == 'facebook'
  end

end

