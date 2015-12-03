class Dashboard::Admin::CoursesController < AdminController
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

  def create
    @course = Course.create(course_params)
    if @course.save
      flash[:notice] = "Course was succesfully created"
      redirect_to admin_course_path(@course)
    else
      flash[:alert] = "Course was not created: #{@course.errors.full_messages}"
      render :new
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

  #======================================================================================
  #       Custom Actions for Adding Course Lists (creating mutliple courses at once)
  #======================================================================================

  def new_course_list
    @school = School.find(params[:course_list_setup][:school_id].to_i)
    @subject = Subject.find(params[:course_list_setup][:subject_id].to_i)
    @form_length = params[:course_list_setup][:form_length]
  end

  def review_new_course_list
    @course_list = params[:course_list]
    @school = School.find(params[:school_id].to_i)
    @subject = Subject.find(params[:subject_id].to_i)
  end

  def create_new_course_list
    if Course.create_course_list(params)
      flash[:notice] = "Course list was succesfully created"
      redirect_to admin_courses_path
    else
      flash[:error] = "Course list was not created"
      redirect_to :back
    end
  end

  private 

    def set_course
      @course = Course.find(params[:id])
    end

    def course_params
      params.require(:course).permit(:call_number, :friendly_name, :school_id, :subject_id)
    end

end