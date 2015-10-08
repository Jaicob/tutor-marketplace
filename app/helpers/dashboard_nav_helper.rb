# Note for later!
# One approach to re-do this in a more Rails way and one which allows for testing is here:
# http://railscasts.com/episodes/287-presenters-from-scratch


module DashboardNavHelper

  def get_user_type
    if current_user.tutor then :tutor else :student end
  end

  def generate_dashboard_nav_links
    # user must be signed in to view dashbar pages
    return false unless user_signed_in?
      courses_link            = dashboard_user_courses_path(current_user)
      promotions_link         = dashboard_user_promotions_path(current_user)
      profile_link            = profile_dashboard_user_path(current_user)
      settings_link           = account_settings_dashboard_user_path(current_user)
      school_and_courses_link = dashboard_link
      reports_link            = dashboard_link
      become_a_tutor_link     = new_tutor_path
      tutor_search_link       = search_path

    all_dashboard_links = {
      tutor: {
        # name seen on the dashboard nav => where it links to
        'Home'      => home_tutor_path(current_user.id),
        'Schedule'  => schedule_tutor_path(current_user.id),
        'Courses'   => tutor_courses_path,
        'Promotions' => promotions_link,
        'Profile'   => profile_link,
        'Settings'  => settings_link
      },

      student: {
        'Home'          => home_student_path,
        'Settings'      => account_student_path,
        'Find a Tutor'  => tutor_search_link,
      },

      admin: {
        'Home'         => dashboard_link,
        'Tutors'            => schedule_link,
        'Reports'           => reports_link,
        'Schools & Courses' => school_and_courses_link,
        'Settings'          => settings_link,
        'Find a Tutor'      => tutor_search_link,
      }
    }

    user_type = get_user_type()
    @dashboard_links = all_dashboard_links[user_type]

    @dashboard_links.each do |name, link|
      @current = name if request.fullpath.start_with? link
    end
  end

end
