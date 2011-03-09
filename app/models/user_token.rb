class UserToken < ActiveRecord::Base
  belongs_to :user
  after_create :pull_data_from_facebook


  def pull_data_from_facebook
    self.user.delay.fetch_fb_feeds if self.provider == 'facebook'
  end

end

