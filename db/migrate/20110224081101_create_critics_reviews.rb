class CreateCriticsReviews < ActiveRecord::Migration
  def self.up
    create_table :critics_reviews do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :critics_reviews
  end
end
