class SiteInfo < ApplicationRecord

	def plaintext
		ActionView::Base.full_sanitizer.sanitize(self.value)
	end

	def htmlvalue
		self.value.html_safe
	end
end
