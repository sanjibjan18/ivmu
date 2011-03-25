class Activity < ActiveRecord::Base
  belongs_to :actor, :class_name => 'User'
  belongs_to :subject, :polymorphic => true
  belongs_to :secondary_subject, :polymorphic => true

  scope :latest, order('created_at desc nulls last')
  scope :limit, lambda{|l| limit(limit) }
  scope :actor_ids, lambda{|ids| where("actor_id in (?)", ids) }

  validates_presence_of :action

  def self.log_activity(subject, secondary_subject, activity, actor_id)
     self.create(:subject => subject,:secondary_subject => secondary_subject, :action => activity, :actor_id => actor_id)
  end


  def self.friend_activities(user)
     return [] if user.facebook_friends_ids.blank?
     user_ids = UserToken.where("provider = ? and uid in (?)", 'facebook', user.facebook_friends_ids).collect(&:user_id)
     return [] if user_ids.blank?
     self.actor_ids(user_ids).latest.limit(4)
  end


end

