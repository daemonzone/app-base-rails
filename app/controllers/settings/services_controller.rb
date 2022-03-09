class Settings::ServicesController < ApplicationController
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :is_admin?, except: [:index]

  layout 'application'
  
  def index
    if (params[:category_id])
      @services = Service.where(:category_id => params[:category_id]).order(title: :asc)
    else
      @services = Service.where("category_id is null").order(title: :asc)
    end

    respond_to do |format|
      format.html { render 'settings/services/index', :layout => false }
      format.json { render :json => @services }
    end
  end

  def create
  	@service = Service.create(service_params)
  	unless @service.valid?
  		flash[:alert] = "Errore nella creazione del Servizio"
  	end
    
    @services = Service.where("category_id is null").order(title: :asc)
  end

  def destroy
	  @service = Service.find(params[:id])
    @service.destroy

    @services = Service.where("category_id is null").order(title: :asc)

	  respond_to do |format|
      format.html { redirect_to settings_categories_path }
      format.json { head :no_content }
	  end
  end

  private
  
  def service_params
    params.require(:service).permit([:title])
  end
end
