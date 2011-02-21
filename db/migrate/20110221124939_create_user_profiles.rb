class CreateUserProfiles < ActiveRecord::Migration
  def self.up
    create_table :user_profiles do |t|
      t.string :display_name
      t.string :dob
      t.string :sex

      t.timestamps
    end
  end

  def self.down
    drop_table :user_profiles
  end
end
