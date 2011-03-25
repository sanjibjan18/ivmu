class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.integer  "actor_id"
      t.integer  "subject_id"
      t.string   "subject_type"
      t.string   "action"
      t.timestamps
    end
    add_index :activities, [:subject_id, :subject_type]
    add_index :activities, :actor_id
  end

  def self.down
    drop_table :activities
  end
end

