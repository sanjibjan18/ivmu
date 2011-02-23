class UserProfile < ActiveRecord::Base
  belongs_to :user
  validates_uniqueness_of :display_name
end

