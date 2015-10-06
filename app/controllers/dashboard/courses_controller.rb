class Dashboard::CoursesController < DashboardController
  before_action :set_tutor_course, only: [:show, :update, :destroy]

  def index
    @tutor_course = TutorCourse.new
  end

  def show
  end

  def update
    if @tutor_course.update(tutor_course_params)
      redirect_to dashboard_tutor_course_path(@tutor_course)
    end
  end

  def destroy
    if @tutor_course.destroy
      redirect_to dashboard_tutor_courses_path(current_user)
    end
  end

  private

    def tutor_course_params
      params.require(:tutor_course).permit(:tutor_id, :course_id, :rate)
    end

    def set_tutor_course
      @tutor_course = TutorCourse.find(params[:id])
    end

end
