# Note for later!
# One approach to re-do this in a more Rails way and one which allows for testing is here:
# http://railscasts.com/episodes/287-presenters-from-scratch


module DashboardNavHelper

  def generate_dashboard_nav_links
    # user must be signed in to view dashbar pages
    return false unless user_signed_in?

    all_dashboard_links = {
      tutor: {
        # name seen on the dashboard nav => where it links to
        'Home'      => home_tutor_path(@tutor.slug),
        'Schedule'  => schedule_tutor_path(@tutor.slug),
        'Courses'   => tutor_courses_path(@tutor.slug),
        'Promotions' => tutor_promotions_path(@tutor.slug),
        'Profile'   => profile_tutor_path(@tutor.slug),
        'Settings'  => account_tutor_path(@tutor.slug)
      },

      student: {
        'Home'          => home_student_path(@student.slug),
        'Settings'      => account_student_path(@student.slug),
        'Find a Tutor'  => search_path,
      },

      # admin: {
      #   # 'Home'              => dashboard_link,
      #   # 'Tutors'            => schedule_link,
      #   # 'Reports'           => reports_link,
      #   # 'Schools & Courses' => school_and_courses_link,
      #   # 'Settings'          => settings_link,
      # }
    }

    user_type = current_user.role.to_sym
    @dashboard_links = all_dashboard_links[user_type]

    @dashboard_links.each do |name, link|
      @current = name if request.fullpath.start_with? link
    end
  end

end
