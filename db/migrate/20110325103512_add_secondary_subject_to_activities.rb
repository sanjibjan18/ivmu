class AddSecondarySubjectToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :secondary_subject_id, :integer
    add_column :activities, :secondary_subject_type, :string
    add_index :activities, [:secondary_subject_id, :secondary_subject_type], :name => 'secondary_subject'
  end

  def self.down
    remove_column :activities, :secondary_subject_type
    remove_column :activities, :secondary_subject_id
  end
end

