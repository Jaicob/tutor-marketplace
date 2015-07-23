class Dashboard::CoursesController < DashboardController

  def index
    @tutor_course = TutorCourse.new
  end

end
