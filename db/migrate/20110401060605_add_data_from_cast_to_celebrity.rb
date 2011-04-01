class AddDataFromCastToCelebrity < ActiveRecord::Migration
  def self.up
    Cast.all.each do |cast|
      unless cast.movie_casts.blank?
         celebrity = Celebrity.create!(:name => cast.name)
         cast.movie_casts.each do |movie_cast|
           movie_cast.update_attributes({:celebrity_id => celebrity.id})
         end
      end
    end
  end

  def self.down
  end
end

