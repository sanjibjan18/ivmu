class Admin::FilmCriticsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin?
  layout 'admin'

  def index
     @film_critics = FilmCritic.all
  end

  def show
    @film_critic = FilmCritic.find(params[:id])
  end

  def new
   @film_critic = FilmCritic.new
  end

  def edit
    @film_critic = FilmCritic.find(params[:id])
  end

  def create
    @film_critic = FilmCritic.new(params[:film_critic])

    respond_to do |format|
      if @film_critic.save
        format.html { redirect_to(admin_film_critics_path, :notice => 'Film Critic was successfully created.') }
        format.xml  { render :xml => @film_critic, :status => :created, :location => @film_critic }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @film_critic.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @film_critic = FilmCritic.find(params[:id])

    respond_to do |format|
      if @film_critic.update_attributes(params[:film_critic])
        format.html { redirect_to(admin_film_critics_path, :notice => 'Film Critic was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @film_critic.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @film_critic = FilmCritic.find(params[:id])
    @film_critic.destroy
    redirect_to(admin_film_critics_url)
  end
end

