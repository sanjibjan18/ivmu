class AddAliasNameToMovies < ActiveRecord::Migration
  def self.connection
    Movie.connection
  end
  def self.up
    add_column :films, :alias_name, :string
    change_column :films, :gross_revenue, :decimal, :precision => 8, :scale => 2, :default => 0.0
  end

  def self.down
  end
end

