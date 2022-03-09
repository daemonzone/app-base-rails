class Account::UsersController < ApplicationController
  protect_from_forgery with: :exception
  before_action :authenticate_user!, except: [:show, :modal]
  before_action :is_admin?, except: [:show, :modal, :public_backgrounds]
  before_action :check_notification_and_messages, except: [:show, :modal, :search, :public_backgrounds]

	def index
  		if current_user.is_admin?
			# @users = User.joins('LEFT JOIN categories ON users.category_id = categories.id')
			# 			 .joins('LEFT JOIN services ON users.service_id = services.id')
			# 			 .joins('LEFT JOIN requests ON users.id = requests.user_id')
			# 			 .select("users.*, categories.title as user_category, services.title as user_service, requests.user_id, count(*) as requests_count")
			# 			 .where(:usertype => User.usertypes[:partner]).order(ragionesociale: :asc)
			# 			 .group("users.id, categories.title, services.title, requests.user_id")
			# 			 .page(params[:page]).per(7)

			@users = User.where(:usertype => User.usertypes[:partner])
						 .includes(:category)
						 .includes(:service)
						 .includes(:requests)
						 .order(ragionesociale: :asc)
						 .page(params[:page]).per(10)

	        if params[:prov]
    	    	@users = @users.where(:prov => params[:prov]) unless params[:prov].empty?
    	    end
    	    @services = {}
	        if params[:category]
    	    	@users = @users.where(:category_id => params[:category]) unless params[:category].empty?
			    @services = Service.where(:category_id => params[:category]).order("services.title") unless params[:category].empty?
    	    end
	        if params[:service]
    	    	@users = @users.where(:service_id => params[:service]).order("services.title") unless params[:service].empty?
    	    end
    	    if params[:searchtext]
    	    	@users = @users.where("users.ragionesociale ilike :searchtext OR users.fullname ilike :searchtext OR users.email ilike :searchtext", 
    	    						  searchtext: "%#{params[:searchtext]}%") unless params[:searchtext].empty?
    	    end
    	  	    	    
    	    @params = params
		end
	end

	def show
		@user = User.find_by :public_url => params[:id]
		if @user.nil? || !@user.active? || @user.subscription.nil? || @user.subscription.subscription_type != 'premium' || @user.subscription.expired?
			redirect_to root_path
		end
	end

	def modal
		@user = User.find_by :public_url => params[:id]
		if @user.nil? || !@user.active? || @user.subscription.nil? || @user.subscription.subscription_type != 'premium' || @user.subscription.expired?
			redirect_to root_path
		end
		render 'account/users/show', layout: false
	end

	def new
		@user = User.new
	    @categories = Category.where(:active => true).order(title: :asc)    
	    @services = Service.where(:category_id => @user.category_id).order(title: :asc)
	end

	def create
		@user = User.new(current_user_params)
		@user.password = SecureRandom.hex
		@user.confirmed_at = DateTime.now
		@user.skip_confirmation_notification!
		if @user.save!
	    	NotificationMailer.with(resource: @user).welcome_email.deliver_later
			@user.send_reset_password_instructions
			redirect_to account_users_path(@user), notice: "Utente aggiunto"
		else
			logger.debug @user.errors.full_messages
			redirect_to request.referrer, flash: { error: @user.errors.full_messages }
		end
  	rescue ActiveRecord::RecordNotUnique, ActiveRecord::RecordInvalid
	    @categories = Category.where(:active => true).order(title: :asc)    
	    @services = Service.where(:category_id => @user.category_id).order(title: :asc)

		flash[:error] = "Esiste già un utente con questo indirizzo email"
		render 'account/users/new'
	end

	def edit
		@user = User.find_by(:id => params[:id], :usertype => User.usertypes[:partner])
		if @user.nil? 
			flash[:alert] = "Utente non trovato"
			redirect_to (request.referrer.present? ? request.referrer : account_users_path)
		else
	    	@categories = Category.where(:active => true).order(title: :asc)    
	    	@services = Service.where(:category_id => @user.category_id).order(title: :asc)
	    end

	    @public = params.include?("public")
	end

	def newsletter
  		if current_user.is_admin?
  			@users = User.where(:usertype => User.usertypes[:user])
  						 .includes(:form_requests)
  						 .order(fullname: :asc)
			
			@users = Kaminari.paginate_array(@users)  						 
  						 	 .page(params[:page]).per(10)
		end
	end

	def requests
	    @user = User.find(params[:id])
	    if @user.usertype == 'user'
	    	@requests = @user.form_requests.order('created_at desc')
	    else 
	    	@requests = @user.requests.order('created_at desc')
	    end
	    render :layout => false		
	end

	def update
	  	@user = User.find(params[:id])

	  	# Notifications 
	  	if @user.docsuploaded 
	  		if params[:user][:docsuploaded]
		  		# Documents have been rejected
				message = "E' necessario rivedere o inviare nuovamente la documentazione"
				@notification = Notification.create(:source => 'admin', :user_id => @user.id, :notification_type => 'alert', :message => message, :notification_url => account_documents_url)
			    NotificationMailer.with(notification: @notification, user: @user, to: @user.email, subject: message).documents_rejected.deliver_later
	  		end
	  	end

	  	if !@user.active
	  		if params[:user][:active]
	  			params[:user][:docsuploaded] = true	# Force docsuploaded to true (so not to bother the admin)		  		
		  		# Account has been activated
				message = "Il tuo Account è stato attivato"
				@notification = Notification.create(:source => 'admin', :user_id => @user.id, :notification_type => 'success', :message => message)
			    NotificationMailer.with(notification: @notification, user: @user, to: @user.email, subject: message).profile_activated.deliver_later
			end
	  	end

	    if @user.update(current_user_params)
	      flash[:notice] = "Utente aggiornato!"
	    else
	      flash[:alert] = "Si è verificato un errore"
	    end

	    redirect_to account_users_path
	end

	def search
		prov 	   = params[:prov]
		searchtext = params[:searchtext]
		service    = params[:service]
		form_request_id = params[:form_request]

    	@already_forwarded = []
    	if form_request_id
			@form_request = FormRequest.find(form_request_id)
    		@already_forwarded = @form_request.requests.pluck(:user_id) if @form_request
    	end

    	@recipients  = User.joins('LEFT JOIN categories ON users.category_id = categories.id')
                        .joins('LEFT JOIN services ON users.service_id = services.id')
                        .select("users.*, categories.title as user_category, services.title as user_service")             
                        .where.not(:id => @already_forwarded)
                        .where(:active => true,
                              :usertype => User.usertypes[:partner],
                              :prov => prov)
                        .where("users.ragionesociale ilike ?", "%#{searchtext}%")
        
        if params[:service] && !params[:service].empty?
        	@recipients = @recipients.where(:service_id => params[:service]) unless params[:service].empty?
        else
        	@recipients = @recipients.where(:category_id => params[:category]) unless params[:category].empty?
        end

        @recipients = @recipients.order("NULLIF(CAST(subscription_data AS VARCHAR), '') DESC NULLS LAST")

	    respond_to do |format|
	        format.html { render 'account/users/search', :layout => false }
	        format.js { render 'account/users/search', :layout => false }
		end		
	end

	def add_credits
		if params[:credits_amount] && params[:credits_amount].to_i > 0
			Transaction.create!(:user_id => params[:user_id],
			                    :amount => params[:credits_amount],
			                    :transaction_type => Transaction.transaction_types[:in],
			                    :description => "[AVQ] Aggiunti #{params[:credits_amount]} crediti"
			                 )
			flash[:notice] = "Crediti aggiunti correttamente!"
		end

		redirect_to request.referrer
	end

	def add_subscription
		if params[:user_id]
	        # @subscription = Subscription.create!(:user_id => params[:user_id],
	        #                      :title => order.product_title,
	        #                      :subscription_type => product_to_deliver[:subscription],
	        #                      :duration => 365, 
	        #                      :expiration => DateTime.now + 1.year, 
	        #                      :order_id => order.id
	        #                     )
	        user = User.find(params[:user_id])
	        expiry_date = Date.strptime(params[:subscription_expiry], "%d/%m/%Y")
	        unless user.nil?
		        user.update(subscription_data: { 
	                          subscription_type: (params[:subscription_type] == '0' ? 'basic' : 'premium'),
	                          expiration: "#{expiry_date}", 
	                          id: SecureRandom.uuid
	                          })
	        end

			flash[:notice] = "Abbonamento attivato correttamente!"
		end

		redirect_to request.referrer
	end

	def remove_subscription
		if params[:user_id]
	        user = User.find(params[:user_id])
	        unless user.nil?
		        user.update(subscription_data: nil)
	        end

			flash[:notice] = "Abbonamento disattivato!"
		end

		redirect_to request.referrer
	end

	def destroy
   		@user = User.find(params[:id])

   		# First remove ALL user objects
		@user.orders.destroy_all
		@user.subscriptions.destroy_all
		@user.transactions.destroy_all
		Notification.where(:user_id => @user.id).destroy_all
		Message.where(:from_id => @user.id).destroy_all
		Message.where(:to_id => @user.id).destroy_all
		@user.requests.destroy_all
		@user.form_requests.destroy_all

      	if @user.destroy!
	      	flash[:notice] = "Utente cancellato"
			redirect_to (@user.usertype == 'partner' ? account_users_path : request.referrer) 
	    end
   	rescue ActiveRecord::InvalidForeignKey => error
      	flash[:error] = "Errore: una o più richieste fanno riferimento a questo utente <br /><br /><small>#{error.to_json}</small>" 
		redirect_to (@user.usertype == 'partner' ? edit_account_user_path(@user) : request.referrer) 
	end

	private

	def current_user_params
		params.require(:user).permit(User.secure_params)
	end
end


# Request.create(:title => "Idraulico Urgente", :form_request_id => '33207a90-5338-429f-923f-1e4affdd1498', :customer_id => '7baea696-ec57-4e67-9877-af291c956793', :user_id => '26f0cc7d-377c-4913-84e2-0c4726186c79', :status => 0, :category_id => 10, :service_id => 2)
