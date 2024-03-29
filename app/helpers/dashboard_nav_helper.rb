# Note for later!
# One approach to re-do this in a more Rails way and one which allows for testing is here:
# http://railscasts.com/episodes/287-presenters-from-scratch


module DashboardNavHelper

  def generate_dashboard_nav_links
    # user must be signed in to view dashboard pages
    return false unless user_signed_in?
    
    if current_user.role == 'tutor'
      @dashboard_links = {
        'Home'      => home_tutor_path(@tutor.slug),
        'Schedule'  => schedule_tutor_path(@tutor.slug),
        'Courses'   => tutor_courses_path(@tutor.slug),
          # 'Promotions' => tutor_promotions_path(@tutor.slug),
          # TODO-JT - finish working on Tutor created Promotions and add this link back in
        'Profile'   => profile_tutor_path(@tutor.slug),
        'Settings'  => account_tutor_path(@tutor.slug)
      }
    else
      @dashboard_links = {
        'Home'          => home_student_path(current_user),
        'Find a Tutor'  => search_path,
        'Settings'      => account_student_path(current_user)
      }
    end

    @dashboard_links.each do |name, link|
      @current = name if 
        (request.fullpath.start_with? link) ||
        (request.fullpath.to_s.split('/').include? name.downcase)
    end
    @dashboard_links
  end
end