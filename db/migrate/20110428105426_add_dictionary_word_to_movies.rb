class AddDictionaryWordToMovies < ActiveRecord::Migration
  def self.connection
    Movie.connection
  end
  def self.up
    add_column :films, :dictionary_word, :boolean, :default => false
    add_index :films, :dictionary_word
    add_index :films, :media_updated_date
    Movie.all.each do |movie|
      movie.update_attribute('dictionary_word', false)
    end
  end

  def self.down
  end
end

