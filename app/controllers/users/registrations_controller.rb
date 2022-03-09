# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  def new
    @categories = Category.where(:active => true).order(title: :asc)
    super
  end

  def create
    @categories = Category.where(:active => true).order(title: :asc)
    
    # Simple Anti-Spam Rule (hidden surname field cannot be filled in by a real user)
    if params[:user][:surname] && !params[:user][:surname].empty?
      logger.debug('==================> Bot detected')
      redirect_to page_show_path(slug: 'confirmation', data: "Grazie per esserti registrato!")
    else
      super
      # Notify Admin of the new user subscription
      if @user.errors.empty?
        AdminNotificationMailer.with(user: @user).new_user_submitted.deliver_later
      end
    end
  end
  
  def edit
  end
  
  # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      set_flash_message_for_update(resource, prev_unconfirmed_email)
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?

      respond_with resource, location: after_update_path_for(resource)

    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end  
  
  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: User.secure_params)
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: User.secure_params)
  end

  # After password change
  def after_update_path_for(resource)
    account_path
  end

  # The path used after sign up.
  def after_sign_up_path_for(_resource)
    account_path
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    page_show_path(slug: 'confirmation', data: flash[:notice])
  end
  
end