class SearchController < ApplicationController
  skip_before_filter :authenticate_user!
  layout 'website'

  def index

    name = {:name_contains => params[:q]}
    @search = Movie.latest.search(name)
    @movies = @search.paginate(:page => params[:page], :per_page => 10)
    @cast_search = Celebrity.search(name)
    @celebrities = @cast_search.paginate(:page => params[:page], :per_page => 10)

    if @movies.size == 1 && @celebrities.blank?
      redirect_to movie_path(@movies.first) and return
    end
    if @movies.blank? && @celebrities.size == 1
      redirect_to celebrity_path(@celebrities.first.id) and return
    end

=begin
 my_query = "(SELECT name,id,thumbnail_image FROM \"films\" WHERE (\"films\".\"name\" ILIKE '%#{params[:q]}%')) union (SELECT name, id,thumbnail_image FROM \"casts\" WHERE (\"casts\".\"name\" ILIKE '%#{params[:q]}%'))"


puts "ppppppppppp #{my_query}"
total_entries = ActiveRecord::Base.connection.execute("#{my_query}").count.to_i

results = ActiveRecord::Base.connection.select_rows("#{my_query}")
puts "ppppppppppp #{results}"
=end
  end
end

