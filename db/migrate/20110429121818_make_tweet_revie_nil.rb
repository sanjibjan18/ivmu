class MakeTweetRevieNil < ActiveRecord::Migration
  def self.up
   Tweet.where(:review => false).all.each  do |tweet|
     tweet.update_attribute('review', nil)
   end
  end

  def self.down
  end
end

