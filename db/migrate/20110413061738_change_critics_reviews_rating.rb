class ChangeCriticsReviewsRating < ActiveRecord::Migration
  def self.up
    change_column :critics_reviews, :rating, :float
  end

  def self.down
  end
end
