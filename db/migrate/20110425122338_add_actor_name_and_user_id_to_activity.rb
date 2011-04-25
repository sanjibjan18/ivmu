class AddActorNameAndUserIdToActivity < ActiveRecord::Migration
  def self.up
    add_column :activities, :user_id, :integer
    add_column :activities, :actor_name, :string
  end

  def self.down
  end
end

