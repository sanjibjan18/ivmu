class VideosController < ApplicationController
 def index
    @videos = Video.find :all
  end

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(params[:video])
    if @video.save
      @video.convert
      flash[:notice] = 'Video has been uploaded'
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end

  def show
    @video = Video.find(params[:id])
  end
  
  def delete
    @video = Video.find(params[:id])
    @video.destroy
    redirect_to :action => 'index'
  end
end
