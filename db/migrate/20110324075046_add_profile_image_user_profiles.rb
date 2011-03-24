class AddProfileImageUserProfiles < ActiveRecord::Migration
  def self.up
    add_column :user_profiles, :profile_image_file_name,    :string
    add_column :user_profiles, :profile_image_content_type, :string
    add_column :user_profiles, :profile_image_file_size,    :integer
  end

  def self.down
    remove_column :user_profiles, :profile_image_file_name
    remove_column :user_profiles, :profile_image_content_type
    remove_column :user_profiles, :profile_image_file_size
  end
end

