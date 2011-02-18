class CreateRecommendedTos < ActiveRecord::Migration
  def self.up
    create_table :recommended_tos do |t|
      t.integer :recommendation_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :recommended_tos
  end
end
