class Admin::SettingsController < ApplicationController
  layout 'admin'
  before_filter :authenticate_user!

  def index
    @search  = Setting.search((params[:search] || {}).merge({"meta_sort"=>"name.asc"}) )
    @settings = @search.paginate(:page => params[:page], :per_page => 100)
  end


  def new
    @setting = Setting.new
  end


  def edit
    @setting = Setting.find(params[:id])
  end


  def create
    @setting = Setting.new(params[:setting])
    if @setting.save
      redirect_to(admin_settings_path, :notice => 'setting was successfully created.')
    else
      render :action => "new"
    end
  end


  def update
    @setting = Setting.find(params[:id])
    if @setting.update_attributes(params[:setting])
       redirect_to(admin_settings_path, :notice => 'setting was successfully updated.')
    else
      render :action => "edit"
    end
  end


  def destroy
    @setting = Setting.find(params[:id])
    @setting.destroy
    redirect_to(admin_settings_url)
  end

end

