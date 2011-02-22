class FacebookFeed < ActiveRecord::Base
  belongs_to :user
  scope :facebook_friend_likes, lambda{|fbid|  where("'fbid' <> ?", fbid)}
  scope :like_name, lambda{|name| where("value like ? ", "#{name}%") }
  scope :by_fb_item_id, lambda{|item_id| where(:fb_item_id => item_id) }
end
