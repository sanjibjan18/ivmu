class AddAncestryToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :ancestry, :string
  end

  def self.down
    remove_column :comments, :ancestry
  end
end
