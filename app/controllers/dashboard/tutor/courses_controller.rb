class Dashboard::Tutor::CoursesController < DashboardController
  before_action :set_tutor_course, only: [:show, :update, :destroy]

  def index
    @all_options_for_tutor = true 
    @tutor_course = TutorCourse.new
  end

  def create
    @tutor_course = TutorCourse.create(tutor_course_params)
    if @tutor_course.save
      redirect_to tutor_courses_path(@tutor.slug)
    else
      redirect_to :back
      flash[:error] = "Course was not added to your course list!"
    end
  end

  def show
  end

  def update
    if @tutor_course.update(tutor_course_params)
      redirect_to tutor_courses_path(@tutor.slug)
    end
  end

  def destroy
    if @tutor_course.destroy
      redirect_to tutor_courses_path(@tutor.slug)
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