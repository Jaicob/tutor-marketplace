module DashboardNavHelper

	def show_dashboard_nav?
		dashboard_link = "/dashboard"
		schedule_link  = dashboard_link + "/schedule"
		courses_link  = dashboard_link + "/courses"
		profile_link  = dashboard_link + "/profile"
		settings_link  = dashboard_link + "/settings"

		user_type = if current_user.tutor then :tutor else :student end

		all_dashboard_links = {
			tutor: {
				# name seen on the dashboard nav => where it links to
				"Dashboard" => dashboard_link,
				"Schedule"  => schedule_link,
				"Courses"   => courses_link,
				"Profile"   => profile_link,
				"Settings"  => settings_link
			},

			student: {
				"Dashboard" => dashboard_link,
				"Settings"  => settings_link,
				"Become a Tutor"  => "/becometutor"
			},

			admin: {
				"Dashboard" => dashboard_link,
				"Tutors"  => schedule_link,
				"Reports"   => courses_link,
				"Schools & Courses"   => profile_link,
				"Settings"  => settings_link
			}
		}

		@dashboard_links = all_dashboard_links[user_type]

		@dashboard_links.each do |name, link|
			@current = name.downcase if request.fullpath.start_with? link
		end

		# check if current page is a dashboard page and if signed in
		@current && user_signed_in?
	end
end
