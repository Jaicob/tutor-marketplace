module ApplicationHelper

	def show_dashboard_nav?
		@dashboard_links = {
			# name seen on the dashboard nav => where it links to
			"Dashboard" => "/dashboard",
			"Schedule"  => "/dashboard/schedule",
			"Courses"   => "/dashboard/courses",
			"Profile"   => "/dashboard/profile",
			"Settings"  => "/dashboard/settings"
		}

		@dashboard_links.each do |name, link|
			@current = name.downcase if request.fullpath.start_with? link
		end

		# check if current page is a dashboard page and if signed in
		@current && user_signed_in?
	end

end
