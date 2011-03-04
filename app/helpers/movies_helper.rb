module MoviesHelper

  def no_of_pepople_liked(movie)
    if current_user
      link_to ((movie.fb_friends_liked(current_user).count rescue 0).to_s +  ' friends liked it!'), '#'
    #else
      # '0 friends liked it!'
    end
  end
end

