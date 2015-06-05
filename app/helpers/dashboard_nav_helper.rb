module DashboardNavHelper

  def show_dashboard_nav
    # user must be signed in to view dashbar pages
    return false unless user_signed_in?
    tutor_id = current_user.tutor.id
    dashboard_link          = dashboard_tutor_path(tutor_id)
    schedule_link           = schedule_tutor_path(tutor_id)
    courses_link            = courses_tutor_path(tutor_id)
    profile_link            = profile_tutor_path(tutor_id)
    settings_link           = settings_tutor_path(tutor_id)
    school_and_courses_link = dashboard_link
    reports_link            = dashboard_link

    user_type = if current_user.tutor then :tutor else :student end

    all_dashboard_links = {
      tutor: {
        # name seen on the dashboard nav => where it links to
        'Dashboard' => dashboard_link,
        'Schedule'  => schedule_link,
        'Courses'   => courses_link,
        'Profile'   => profile_link,
        'Settings'  => settings_link
      },

      student: {
        'Dashboard'      => dashboard_link,
        'Settings'       => settings_link,
        'Become a Tutor' => '/becometutor'
      },

      admin: {
        'Dashboard'         => dashboard_link,
        'Tutors'            => schedule_link,
        'Reports'           => reports_link,
        'Schools & Courses' => school_and_courses_link,
        'Settings'          => settings_link
      }
    }

    @dashboard_links = all_dashboard_links[:tutor]

    @dashboard_links.each do |name, link|
      @current = name if request.fullpath.start_with? link
    end
  end

end
