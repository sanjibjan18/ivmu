class CreateSiteStats < ActiveRecord::Migration
  def self.up
    create_table :site_stats do |t|
      t.integer :movies_count
      t.integer :reviews_count
      t.integer :celebrities_count

      t.timestamps
    end
    st = SiteStat.new
    st.movies_count = Movie.count
    st.reviews_count = CriticsReview.count
    st.celebrities_count = Celebrity.count
    st.save
  end

  def self.down
    drop_table :site_stats
  end
end

