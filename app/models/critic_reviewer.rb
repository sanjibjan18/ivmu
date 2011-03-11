class CriticReviewer < ActiveRecord::Base
  set_table_name 'film_critics'
  has_many :critics_reviews
end

