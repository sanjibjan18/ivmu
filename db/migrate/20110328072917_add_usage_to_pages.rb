class AddUsageToPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :usage, :string
    add_column :pages, :permalink, :string
  end

  def self.down
    remove_column :pages, :permalink
    remove_column :pages, :usage
  end
end

