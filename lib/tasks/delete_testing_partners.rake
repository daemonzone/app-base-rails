task :delete_testing_partners => :environment do
	User.where(:test_user => true).each do |user|
		user.orders.destroy_all
		user.subscriptions.destroy_all
		user.transactions.destroy_all
		Notification.where(:user_id => user.id).destroy_all
		Message.where(:from_id => user.id).destroy_all
		Message.where(:to_id => user.id).destroy_all
		user.requests.destroy_all
		user.form_requests.destroy_all
		user.destroy
	end
end