class AddColumnToMovie < ActiveRecord::Migration
  def self.connection
    Movie.connection
  end
  def self.up
    add_column :films, :fbpage_id, :string
  end

  def self.down
  end
end

