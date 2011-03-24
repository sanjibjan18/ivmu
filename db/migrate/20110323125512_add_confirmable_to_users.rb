class AddConfirmableToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :confirmation_token,   :string
    add_column :users, :confirmed_at,         :datetime
    add_column :users, :confirmation_sent_at, :datetime

  end

  def self.down
  end
end

