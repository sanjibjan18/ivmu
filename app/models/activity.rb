class Activity < ActiveRecord::Base
  belongs_to :actor, :class_name => 'User'
  belongs_to :subject, :polymorphic => true
  belongs_to :secondary_subject, :polymorphic => true

  scope :latest, order('created_at desc nulls last')
  scope :limit, lambda{|l| limit(limit) }
  scope :actor_ids, lambda{|ids| where("actor_id in (?)", ids) }

  validates_presence_of :action

  def self.log_activity(subject, secondary_subject, action, actor_id)
    activity = Activity.where('actor_id = ?', actor_id).last
    h = {:subject => subject,:secondary_subject => secondary_subject, :action => action}
    if activity.blank?
      self.create(h.merge!({:actor_id => actor_id}))
    else
      activity.update_attributes(h)
    end
  end


  def self.fb_log(subject, secondary_subject, action, actor_name, user_id)
    h = {:subject => subject,:secondary_subject => secondary_subject, :action => action, :user_id => user_id, :actor_name => actor_name}
    count = Activity.where('user_id = ?', user_id).count
    if count.to_i == 4
      Activity.where('user_id = ?', user_id).last.update_attributes(h)
    else
      Activity.create(h)
    end
  end

  def self.create_log_for_each_friend(post, movie, action, facebook_id)
    FacebookFriend.where('facebook_id = ?', facebook_id).each do |friend|
      Activity.fb_log(post, movie, action, friend.user.display_name, friend.user.id)
    end
  end

  def self.friend_activities(user)
     #return [] if user.facebook_friends_ids.blank?
     #user_ids = UserToken.where("provider = ? and uid in (?)", 'facebook', user.facebook_friends_ids).collect(&:user_id)
     #return [] if user_ids.blank?
    # self.actor_ids(user_ids).latest.limit(4)
    self.where('user_id = ?', user.id).limit(4)
  end


end

