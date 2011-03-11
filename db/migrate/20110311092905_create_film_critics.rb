class CreateFilmCritics < ActiveRecord::Migration
  def self.up
    create_table :film_critics do |t|
      t.string :name
      t.string :organization
      t.string :thumbnail

      t.timestamps
    end
  end

  def self.down
    drop_table :film_critics
  end
end

