class Admin::MoviesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin?
  layout 'admin'

  def index
    @search = Movie.search(params[:search])
    @search.meta_sort = "initial_release_date.desc"
    @movies = @search.all.paginate(:page => params[:page], :per_page => 10)
  end

  def show
    @movie = Movie.find_using_id(params[:id]).first
  end

  def new
   @movie = Movie.new
   @movie.build_meta_detail
  end

  def edit
    @movie = Movie.find_using_id(params[:id]).first
    @movie.build_meta_detail if @movie.meta_detail.blank?
  end

  def create
    @movie = Movie.new(params[:movie])

    respond_to do |format|
      if @movie.save
        format.html { redirect_to([:admin, @movie], :notice => 'Movies was successfully created.') }
        format.xml  { render :xml => @movie, :status => :created, :location => @movie }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @movie.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @movie = Movie.find_using_id(params[:id]).first

    respond_to do |format|
      if @movie.update_attributes(params[:movie])
        format.html { redirect_to([:admin, @movie], :notice => 'movie was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @movie.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    redirect_to(admin_movies_url)
  end

end

