task :mirror_subscriptions_to_users => :environment do
	begin
		Subscription.all.order(:user_id, created_at: :asc).each do |subscription|
			user = User.find(subscription.user_id)
			user.update(subscription_data: { subscription_type: subscription.subscription_type, expiration: subscription.expiration,  id: subscription.id })
		rescue ActiveRecord::RecordNotFound
			subscription.destroy
		end
	end
end