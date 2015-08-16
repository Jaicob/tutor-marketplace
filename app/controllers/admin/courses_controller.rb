class Admin::CoursesController < AdminController
  before_action :set_course, only: [:show, :edit, :update, :destroy]

  def search
    index
    render :index
  end

  def index
    @q = current_user.admin_scope(:courses).ransack(params[:q])
    @courses = @q.result.includes(:school, :tutor_courses, :tutors, :appointments)
  end

  def new
    @course = Course.new
  end

  def new_course_list
  end

  def create
    @course = Course.create(course_params)
    @course.set_subject(course_params[:subject][:name])

    if @course.save
      redirect_to admin_course_path(@course)
    else
      flash[:error] = "Course was not created: #{@course.errors.full_messages}"
      render :new
      flash[:error] = "Course was not created: #{@course.errors.full_messages}"
    end
  end

  def show 
  end

  def edit
  end

  def update
    if @course.update(course_params)
      redirect_to admin_course_path(@course)
    else
      flash[:error] = "Course was not updated: #{@course.errors.full_messages}"
      render :edit
    end
  end

  def destroy
    if @course.destroy
      redirect_to admin_courses_path
    else
      render :show
    end
  end

  private 

    def set_course
      @course = Course.find(params[:id])
    end

    def course_params
      params.require(:course).permit(:call_number, :friendly_name, :school_id, subject: [:name])
    end

end