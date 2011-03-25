class Activity < ActiveRecord::Base
  belongs_to :actor, :class_name => 'User'
  belongs_to :subject, :polymorphic => true

  validates_presence_of :action
 
  def self.log_activity(subject, activity, actor_id)
     self.create(:subject => subject, :action => activity, :actor_id => actor_id)
  end
 

end

