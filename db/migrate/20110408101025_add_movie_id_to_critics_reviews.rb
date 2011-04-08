class AddMovieIdToCriticsReviews < ActiveRecord::Migration
  def self.up
    CriticsReview.all.each do |cr|
      hash = {}
      hash[:movie_id]  = (Movie.where(:name => cr.movie_name).first.id rescue nil )
      hash[:film_critic_id]  = (FilmCritic.where(:name => cr.film_critic_name).first.id rescue nil )
      puts "hash :#{hash}"
      cr.update_attributes(hash)
    end

  end

  def self.down
    remove_column :critics_reviews, :movie_id
    remove_column :critics_reviews, :film_critic_id
  end
end

