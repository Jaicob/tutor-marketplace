# Note for later!
# One approach to re-do this in a more Rails way and one which allows for testing is here:
# http://railscasts.com/episodes/287-presenters-from-scratch


module DashboardNavHelper

  def show_dashboard_nav
    # user must be signed in to view dashbar pages
    return false unless user_signed_in?
      dashboard_link          = dashboard_home_user_path(current_user)
      schedule_link           = dashboard_schedule_user_path(current_user)
      courses_link            = dashboard_courses_user_path(current_user)
      profile_link            = dashboard_profile_user_path(current_user)
      settings_link           = dashboard_settings_user_path(current_user)
      school_and_courses_link = dashboard_link
      reports_link            = dashboard_link
      become_a_tutor_link     = new_tutor_path

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
        'Become a Tutor' => become_a_tutor_link
      },

      admin: {
        'Dashboard'         => dashboard_link,
        'Tutors'            => schedule_link,
        'Reports'           => reports_link,
        'Schools & Courses' => school_and_courses_link,
        'Settings'          => settings_link
      }
    }

    @dashboard_links = all_dashboard_links[user_type]

    @dashboard_links.each do |name, link|
      @current = name if request.fullpath.start_with? link
    end
  end

end
