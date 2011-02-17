class RemoveEmailIndex < ActiveRecord::Migration
  def self.up
    remove_index "users",  :column => :email
    add_index :users, :email 
  end

  def self.down
    add_index :users, :email,   :unique => true
  end
end
