class AddReviewToReviews < ActiveRecord::Migration
  def self.up
    add_column :reviews, :review, :boolean, :default => false
    Review.all.each do |review|
      review.update_attributes({:review => false})
    end
  end

  def self.down
    remove_column :reviews, :review
  end
end

