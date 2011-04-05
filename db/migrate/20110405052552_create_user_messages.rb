class CreateUserMessages < ActiveRecord::Migration
  def self.up
    create_table :user_messages do |t|
      t.string :purpose
      t.string :full_name
      t.string :email
      t.string :phone_no
      t.text :message

      t.timestamps
    end
  end

  def self.down
    drop_table :user_messages
  end
end
