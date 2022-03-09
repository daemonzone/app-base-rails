class Account::NotificationsController < ApplicationController
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :check_notification_and_messages

  def show
  	@notification = Notification.where(:id => params[:id], :user_id => current_user.id)

  	unless @notification.empty?
	  	redirect_url = @notification.first.notification_url
	  	@notification.destroy_all

	  	unless redirect_url.nil?
	  		redirect_to redirect_url 
	  		return
	 	end
  	end

  	redirect_to account_path
  end

  def mark_as_read
  	Notification.where(:user_id => params[:user_id]).destroy_all
  	# logger.debug @notifications
  end

end
