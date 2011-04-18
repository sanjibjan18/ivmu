class Admin::CelebritiesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :admin?
  layout 'admin'

  def index
    @search = Celebrity.order_by_name.search(params[:search])
    @celebrities = @search.paginate(:page => params[:page], :per_page => 50)
  end

  def show
    @celebrity = Celebrity.find(params[:id])
  end

  def new
   @celebrity = Celebrity.new
  end

  def edit
    @celebrity = Celebrity.find(params[:id])
  end

  def create
    @celebrity = Celebrity.new(params[:celebrity])

    respond_to do |format|
      if @celebrity.save
        format.html { redirect_to([:admin, @celebrity], :notice => 'Celebrity was successfully created.') }
        format.xml  { render :xml => @celebrity, :status => :created, :location => @celebrity }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @celebrity.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @celebrity = Celebrity.find(params[:id])
    respond_to do |format|
      if @celebrity.update_attributes(params[:celebrity])
        format.html { redirect_to([:admin, @celebrity], :notice => 'Celebrity was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @celebrity.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @celebrity = Celebrity.find(params[:id])
    @celebrity.destroy
    redirect_to(admin_celebrities_url)
  end

  def delete_celebrities
    Celebrity.where('id in (?)', params[:celebrity_ids]).destroy_all unless params[:celebrity_ids].blank?
    redirect_to admin_celebrities_path
  end

  def autocomplete
    celebrity_names = Celebrity.search(:name_contains => params[:term]).all.collect do |user|
      { "label" => user.name, "value" => user.id }
    end
    render :json => celebrity_names.to_json
  end
end

