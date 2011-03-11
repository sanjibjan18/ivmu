class AddCriticReviewerIdToCriticsReviews < ActiveRecord::Migration
  def self.up
    add_column :critics_reviews, :film_critic_id, :integer
  end

  def self.down
    remove_column :critics_reviews, :film_critic_id
  end
end

