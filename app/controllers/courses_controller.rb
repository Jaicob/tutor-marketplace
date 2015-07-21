class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy]

  def index
    @courses = Course.all
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.create(course_params)

    if @course.save
      redirect_to @course
    else
      render :new, error: "Course was not created."
    end
  end

  def show 
  end

  def update
    respond_to do |format|
      if @course.update_attributes(course_params)
        format.json { respond_with_bip(@course)}
      else
        format.json { respond_with_bip(@course)}
      end
    end
  end

  def destroy
    if @course.destroy
      redirect_to courses_path
    else
      render :show
    end
  end

  private 

    def set_course
      @course = Course.find(params[:id])
    end

    def course_params
      params.require(:course).permit(:subject, :call_number, :friendly_name, :school_id)
    end

end
