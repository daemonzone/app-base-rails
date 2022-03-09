class AdminNotificationMailer < ApplicationMailer
  include ApplicationHelper   

  def new_user_submitted
    @user = params[:user]
    mail(to: admins.pluck(:email), subject: "[Utente] Nuovo utente registrato")
  end

  def contact_form_submitted
    @contact_form = params[:contact_form]
    mail(to: admins.pluck(:email), subject: "[Form Contatti] " + @contact_form.subject)
  end

  def form_request_submitted
    @form_request = params[:form_request]
    @notification = params[:notification]    
    mail(to: admins.pluck(:email), subject: "[Nuova Richiesta] " + @form_request.title)
  end

  def documents_submitted
    @user = params[:user]
    unless @user.test_user
      @notification = params[:notification]
      mail(to: admins.pluck(:email), subject: "[Documenti] " + @user.fullname + " ha inviato dei documenti")
    end
  end

  def order_submitted
    @user  = params[:user]
    @order = params[:order]
    unless @user.test_user
      mail(to: admins.pluck(:email), subject: "[Ordine] " + @user.fullname + " effettuato un acquisto")
    end
  end

  def order_submitted_defer
    @user  = params[:user]
    @order = params[:order]
    unless @user.test_user
      mail(to: admins.pluck(:email), subject: "[Ordine] " + @user.fullname + " ha inserito un ordine da confermare")
    end
  end

end