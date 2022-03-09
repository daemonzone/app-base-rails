class AccountsController < ApplicationController
  protect_from_forgery with: :exception
  # before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  before_action :check_edited_profile, except: ['edit']
  before_action :check_notification_and_messages

  def index
    redirect_to account_path
  end

  def show
    @requests = current_user.requests.where(:archived => false).order(created_at: :desc)
    if current_user.is_admin?
      colors = ['#F7464A', '#46BFBD', '#FDB45C', '#949FB1', '#4D5360', '#FF5A5E', '#5AD3D1', '#FFC870', 'A8B3C5', '616774']

      color = 0
      @formrequests_by_category_arr = []
      @formrequests_by_category = FormRequest.joins(:category).select("categories.title, count(*) as total").group("categories.title").order("total desc")
      @formrequests_by_category.each do |fr|
        @formrequests_by_category_arr.push({ value: fr.total, color: colors[color], label: fr.title })
        color+=1
      end

      @users_arr = []
      @users = User.joins(:category).select("categories.title, count(*) as total").group("categories.title").order("total desc")
      @users.each do |fr|
        @users_arr.push({ value: fr.total, color: colors[color], label: fr.title })
        color-=1
      end

    end

    render 'account/dashboard'
  end

  def edit
    @categories = Category.where(:active => true).order(title: :asc)    
    @services = Service.where(:category_id => current_user.category_id).order(title: :asc)
    render 'account/edit'
  end

  def public
    if !current_user.subscription.nil? && current_user.subscription.subscription_type == 'premium'
      render 'account/public'      
    else
      render 'account/public_info_for_basic'
    end
  end

  def public_info_changed
    if !current_user.subscription.nil? && current_user.subscription.subscription_type == 'premium'
      render 'base/dashboard/cards/partner/_warning_public_info_changed_modal', layout: false
    end
  end

  def public_backgrounds
    @bkgrounds = bkimages
    render 'account/public_backgrounds', layout: false
  end

  def update
    if current_user.update(current_user_params)
      flash[:notice] = "Profilo aggiornato!"
    else
      flash[:alert] = "Si è verificato un errore"
    end

    redirect_to account_path

    # Reset confirmation
    # if @user.confirmed?
    #   @user.confirmed_at = nil
    #   @user.save(:validate => false)
    # end    
    # @user = User.find(current_user.id)
    # @user.send_confirmation_instructions      

    # redirect_to account_edit_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up)
    devise_parameter_sanitizer.permit(:account_update)
  end

  private

  def current_user_params
    params.require(:user).permit(User.secure_params)
  end
end
