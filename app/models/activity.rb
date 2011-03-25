class Activity < ActiveRecord::Base
  belongs_to :actor, :class_name => 'User'
  belongs_to :subject, :polymorphic => true

  validates_presence_of :action

  class << self
    def log(subject, action, actor_id)
      self.create(:subject => subject, :action => action, :actor_id => actor_id)
    end
  end

end

