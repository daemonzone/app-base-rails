# frozen_string_literal: true

class Notification < ApplicationRecord

	enum status: [:nuova, :letta, :archiviata]

	belongs_to :user

end

# Notification.create(:user_id => '26f0cc7d-377c-4913-84e2-0c4726186c79', :source => 'test', :request_id => '452df061-cdf1-421e-b90c-264fdbc2fa0e')
