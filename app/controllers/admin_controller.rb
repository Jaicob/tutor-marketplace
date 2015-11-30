class AdminController < DashboardController
  before_action :redirect_non_admin

  def redirect_non_admin
    if !current_user
      redirect_to root_path && return
    elsif current_user.role == 'student'
      redirect_to home_student_path(current_user)
    elsif current_user.role == 'tutor'
      redirect_to home_tutor_path(current_user)
    end
  end

end