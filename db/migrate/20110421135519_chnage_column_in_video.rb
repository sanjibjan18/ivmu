class ChnageColumnInVideo < ActiveRecord::Migration
    def self.connection
    Video.connection
  end
  def self.up
    remove_column :videos, :trailer_updated_at
    add_column :videos, :trailer_updated_at, :datetime
  end

  def self.down
  end
end

