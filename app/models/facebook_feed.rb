class FacebookFeed < ActiveRecord::Base
  belongs_to :user
  scope :facebook_friend_likes, lambda{|fbid|  where("fbid != ?", fbid)}
  scope :like_name, lambda{|name| where("value like ? ", "#{name}%") }
end
