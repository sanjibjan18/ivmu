class UserProfile < ActiveRecord::Base
  belongs_to :user
  validates_uniqueness_of :display_name

   has_attached_file :profile_image, :styles => { :thumb=> "100x100#",:small  => "150x150>" }

end

