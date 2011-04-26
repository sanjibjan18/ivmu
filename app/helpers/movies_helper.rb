module MoviesHelper

  def no_of_pepople_liked(movie)
    if current_user
      link_to ((movie.fb_friends_liked(current_user) rescue 0).to_s +  ' friends liked it!'), '#'
    else
      '0 friends liked it!'
    end
  end

  def option_for_genre
    [['Drama', 'drama'], ['Romance', 'romance'], ['Comedy', 'comedy'], ['Action', 'action'], ['Thriller', 'thriller'], ['Horror','horror']  ]
  end

  def no_of_pepople_interest(movie)
    if current_user
      '2 friends are interested'
    else
      '0 friends are interested'
    end
  end

  def path_for_movie(movie)
    if movie.release_date.blank? || movie.release_date > Date.today
      return coming_soon_movie_path(movie)
    else
      return movie_path(movie)
    end
  end

end

