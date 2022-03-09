class Settings::CategoriesController < ApplicationController
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :set_item, except: [:index, :create, :assoc]
  before_action :check_notification_and_messages
  before_action :is_admin?

  layout 'application'
  
  def index
    @categories = Category.all.order(title: :asc)
    @services   = Service.where("category_id is null").order(title: :asc)    
  end

  def create
  	@category = Category.create(category_params)
  	unless @category.valid?
  		flash[:alert] = "Errore nella creazione della Categoria"
  	end

  	redirect_to settings_categories_path
  end

  def edit
  end

  def update
    if @category.update(category_params)
      flash[:notice] = "Categoria aggiornata"
    else
      flash[:alert] = "Errore di aggiornamento della Categoria"
    end

    if (category_params[:cover])
      redirect_to edit_settings_category_path(@category.id)
    else
      redirect_to settings_categories_path
    end
  end

  def destroy
	  @category = Category.find(params[:id])

    # Orphaned Services are freed
    Service.where(:category_id => @category.id).update_all(:category_id => nil)

	  respond_to do |format|	    
      if @category.destroy

	      format.html { 
	      	flash[:notice] = "Categoria cancellata"
          redirect_to settings_categories_path
	      }
	      format.json { head :no_content }
	    else
	      format.html { redirect_to settings_path }
	      format.json { head :no_content }
	    end

	  end
  end

  # It associates services to the current category
  def assoc
    if params[:services]
      @services = Service.where(id: params[:services]).update_all(:category_id => params[:category])
    end
    
    if params[:services_available]
      @services = Service.where(id: params[:services_available]).update_all(:category_id => nil)
    end

    respond_to do |format|
      data = { :message => 'Tutto a posto!' }
      format.json { render :json => data }
    end
  end

  private

  def set_item
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit([:title, :descr, :cover, :active])
  end
end
