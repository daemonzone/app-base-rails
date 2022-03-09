task :create_partners_for_testing => :environment do
	begin
		1.upto(50) do |index|
			@category = Category.all.sample
			@service = @category.services.sample

		    @user = User.new
		    @user.email = Faker::Internet.email
		    @user.password = '111111'

		    @user.fullname = Faker::Name.name  
		    @user.ragionesociale = Faker::Company.name
		    @user.address =  Faker::Address.street_address
		    @user.city = Faker::Address.city
		    @user.prov = Faker::Address.state_abbr
		    
		    @user.category_id = @category.id
		    @user.service_id = @service.id

		    @user.usertype = 0	# Partner
		    @user.edited = true	    
		    @user.docsuploaded = true
		    @user.active = true

		    @user.test_user = true
		    @user.confirmed_at = DateTime.now

		    subscription = [true, false].sample
		    if subscription
				@user.subscription_data = { 
	                                		subscription_type: ["premium", "basic"].sample,
	                                		expiration: DateTime.now + 1.year, 
	                                		id: SecureRandom.uuid
	                            		  }
			end

		    @user.skip_confirmation_notification!

		    if @user.save
		    	puts "[#{index}] User #{@user.ragionesociale} => #{@user.fullname} <#{@user.email}> added " + (subscription ? 'with a ' + @user.subscription.subscription_type.capitalize + ' subscription' : '')
		    else 
		    	puts @user.errors.to_json
		    	break
		    end   
		rescue Exception => e
	    	puts e.to_json
			next
		end
	end

	# User.where(:test_user => true).each do |u|
	# 	u.profilepic.attach(                
	# 		io: image = open("https://i.pravatar.cc/300"),
	# 		filename: "profilepic_#{u.id}.jpg", 
	# 		content_type: 'image/jpg'
	# 	)
	# end

end

# User.where(:test_user => true).limit(50).update_all(:prov => "TO")
# Subscription.joins(:user).where("users.test_user = true").order(:id).limit(50).update_all(:subscription_type => 0)

# Subscription.all.order(created_at: :desc).where(:subscription_type => 1).limit(50).update_all(:subscription_type => 0)
# Subscription.all.order(created_at: :desc).limit(50).destroy_all