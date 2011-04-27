class AddFacebookIdToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :facebook_id, :string
  end

  def self.down
  end
end

