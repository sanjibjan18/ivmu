class AddReviewColumTopostsAndMovie < ActiveRecord::Migration
  def self.up
    add_column :facebook_feeds, :review, :string
    change_column :tweets, :review, :string
  end

  def self.down
  end
end

