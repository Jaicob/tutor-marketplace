module AdminNavHelper

  def generate_admin_nav_links
    @admin_links = {
      'Schools'       => admin_schools_path,
      'Courses'       => admin_courses_path,
      'Appointments'  => admin_appointments_path,
      'Tutors'        => admin_tutors_path,
      'Students'      => admin_students_path,
      'Reviews'       => admin_reviews_path,      
    }
    if current_user.role == 'admin' # but not for campus_managers
      @admin_links['Promotions'] = admin_promotions_path
      @admin_links['Charges'] = admin_charges_path
    end
    @admin_links.each do |name, link|
      @current = name if 
        (request.fullpath.start_with? link) ||
        (request.fullpath.to_s.split('/').include? name.downcase)
    end

    return @admin_links
  end
end