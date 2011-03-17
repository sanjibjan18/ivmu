class MovieCast < ActiveRecord::Base
  belongs_to :movie, :foreign_key => "movie_name"
  belongs_to :cast, :foreign_key => "cast_name"
end

