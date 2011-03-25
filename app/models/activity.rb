class Activity < ActiveRecord::Base
  belongs_to :actor, :class_name => 'User'
  belongs_to :subject, :polymorphic => true
  belongs_to :secondary_subject, :polymorphic => true

  validates_presence_of :action

  def self.log_activity(subject, secondary_subject, activity, actor_id)
     self.create(:subject => subject,:secondary_subject => secondary_subject, :action => activity, :actor_id => actor_id)
  end


end

