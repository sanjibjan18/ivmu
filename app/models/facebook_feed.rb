class FacebookFeed < ActiveRecord::Base
  belongs_to :user
  scope :facebook_friend_likes, lambda{|fbid|  where("fbid <> ? and feed_type = ?", fbid.to_s, 'friend_likes')}
  scope :like_name, lambda{|name| where("value like ? ", "#{name}%") }
  scope :by_fb_item_id, lambda{|item_id| where(:fb_item_id => item_id) }
end
