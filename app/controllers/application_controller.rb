# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :store_user_location!, if: :storable_location?
  before_action :authenticate_user!, except: ['home', 'category']

  include ApplicationHelper

  layout 'application'

  # Not found - 404
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  rescue
    render 'pages/404'
  end

  # ActiveRecord::RecordNotFound
  rescue_from ActiveRecord::RecordNotFound do |exception|
    redirect_to account_path
  end  

  def home
    @categories = Category.where(:active => true).order(:title).with_attached_cover
  end
  
  def category
    @formrequest = FormRequest.new

    @category = Category.find_by :key => params[:key]
    if @category
      @services = @category.services.order(title: :asc) 
    else
      not_found
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:fullname, :phone])
    devise_parameter_sanitizer.permit(:account_update, keys: [:fullname, :phone])    
  end

  private
 
  def resource_name
    :user
  end
  helper_method :resource_name
 
  def resource
    @resource ||= User.new
  end
  helper_method :resource
 
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
  helper_method :devise_mapping
 
  def resource_class
    User
  end

  def is_admin?
    redirect_to root_path if current_user.nil?
    unless current_user.is_admin?
      redirect_to account_path
    end
  end
  helper_method :is_admin?

  def is_partner?
    redirect_to root_path if current_user.nil?
    unless current_user.is_partner? || current_user.is_admin?
      redirect_to account_path
    end
  end
  helper_method :is_partner?

  def is_active?
    unless current_user.active? || current_user.is_admin?
      redirect_to account_path
    end
  end

  def check_edited_profile
    redirect_to account_edit_path unless (current_user.edited || request.post? || current_user.is_admin? )
  end
  helper_method :check_edited_profile

  def check_notification_and_messages
    @notifications = Notification.where(:user_id => current_user.id).order(created_at: :desc)
    @messages      = Message.where(:archived => false, :to_id => current_user.id, :status => 0)
    if current_user.is_admin?
      @requests_count = FormRequest.where(:archived => false, :status => FormRequest.statuses[:nuova]).count
    else
      # Check subscription validity
      # unless current_user.subscription.nil?
      #   if current_user.subscription.expiration.to_datetime < DateTime.now
      #     current_user.update(:subscription_data => nil)  # Disable the User subscription
      #   end
      # end
      @requests_count = current_user.requests.where(:archived => false, :status => Request.statuses[:nuova]).count
    end
  end
  helper_method :check_notification_and_messages

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? && !request.xhr?
  end

  def store_user_location!
    # :user is the scope we are authenticating
    store_location_for(:user, request.fullpath)
  end
end
