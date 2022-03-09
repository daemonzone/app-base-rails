class SettingsController < ApplicationController
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :check_notification_and_messages
  before_action :is_admin?
  
  def index
  end

  def service
    unless params[:id]
      cat_id = params[:id]
      @services = Service.where(:category_id => cat_id).order(title: :asc)
    end
  end

end
