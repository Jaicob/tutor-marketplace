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
      redirect_to courses_path
    else
      render :new, error: "Course was not created."
    end
  end

  def show 
  end

  def edit
  end

  def update
    @course.update(course_params)

    if @course.save
      redirect_to courses_path
    else
      render :edit, error: "Course was not updated."
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
      params.require(:course).permit(:subject_id, :call_number, :friendly_name, :school_id)
    end

end
