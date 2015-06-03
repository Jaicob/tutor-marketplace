class DashboardController < ApplicationController

	def index
		@content = "dashboard page is here"
	end

	def schedule
		@content = "schedule page is here"
	end

	def courses
		@content = "courses page is here"
	end

	def profile
		@content = "profile page is here"
	end

	def settings
		@content = "settings page is here"
	end

end
