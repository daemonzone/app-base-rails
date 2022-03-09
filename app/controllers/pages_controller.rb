class PagesController < ActionController::Base
  protect_from_forgery with: :exception

  layout 'application'

  rescue_from ActionView::MissingTemplate do |exception|
	  render '404'
  end  	

  def show
  	if params[:slug]

      session[:service]  = "7e4ae185-f8c2-400d-8994-82a09b682bab"
      session[:category] = "33d8bf27-dfbf-49a7-a683-daa7271cb1c0"
      session[:prov]     = "TO"

      # Horrible...
      if params[:slug] == 'request-received-but-checkout-this-guys-before-leaving'
        if session[:service]
          begin
            @service = Service.find(session[:service])
            @category = @service.category

            # session[:service] = nil
          rescue ActiveRecord::RecordNotFound
          end
          logger.debug " ================= SERVICE ===============> " + @service.to_json
        end

        @selection = :service
        @guys = User.where(:usertype => User.usertypes[:partner])
                    .where(:prov => session[:prov])
                    .where(:service_id => session[:service])
                    .where("subscription_data is not null")
                    # .where("CAST(subscription_data AS VARCHAR) like '%premium%'")                    
                    # .where('public_url is not null')
  
        if @guys.size < 4
            @selection = :category
            @guys = User.where(:usertype => User.usertypes[:partner])
                        .where(:prov => session[:prov])
                        .where(:category_id => session[:category])
                        .where("subscription_data is not null")
                        # .where("CAST(subscription_data AS VARCHAR) like '%premium%'")                    
                        # .where('public_url is not null')
        end

        if @guys.size < 4
            @selection = :none
        end

        @guys = @guys.order("RANDOM()").limit(7)
      end

  		@data = params[:data] || ''
  		render params[:slug]
  	end	
  end

  def modal
    if params[:slug]
      @data = params[:data] || ''
      render params[:slug], layout: false
    end 
  end

end