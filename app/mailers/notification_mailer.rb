class NotificationMailer < ApplicationMailer
   before_action :set_to, except: [:test, :welcome_email]
   helper :application

  def documents_rejected
    @user = params[:user]
    @notification = params[:notification]
    mail(to: @to, subject: params[:subject])
  end
  
  def profile_activated
    @user = params[:user]
    mail(to: @to, subject: params[:subject])
  end

  def request_received
    @request = params[:request]
    @notification = params[:notification]    
    mail(to: @to, subject: params[:subject])
  end

  def message_received_user
    @request = params[:request]
    @message = params[:message]
    mail(to: @to, subject: "[AVQ Servizi] Hai ricevuto un nuovo messaggio")
  end

  def message_received_partner
    @request = params[:request]
    @message = params[:message]
    @notification = params[:notification]        
    mail(to: @to, subject: "[AVQ Servizi] Hai ricevuto un nuovo messaggio")
  end

  def order_submitted
    @order = params[:order]
    @user  = params[:user]
    mail(to: @to, subject: "[AVQ Servizi] " + params[:subject])
  end

  def order_confirmed
    @order = params[:order]
    @user  = params[:user]
    mail(to: @to, subject: "[AVQ Servizi] " + params[:subject])
  end

  def test
    mail(to: 'davide@daemonzone.it', subject: "[AVQ Servizi] TEST")    
  end

  def welcome_email
      @resource = params[:resource]
      mail(to: @resource.email, subject: "Iscrizione confermata!")
  end  
    
  private
  
  def set_to
    @to = params[:to]
  end
end

# NotificationMailer.with(:user => User.all.sample).profile_activated.deliver
