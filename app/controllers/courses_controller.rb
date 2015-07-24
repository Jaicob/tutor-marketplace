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
      flash[:error] = "Course was not updated: #{@course.errors.full_messages}"
      render :new
    end
  end

  def show 
  end

  def update
    if @course.update(course_params)
      redirect_to @course
    else
      flash[:error] = "Course was not updated: #{@course.errors.full_messages}"
      render :edit
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
      params.require(:course).permit(:call_number, :friendly_name, :school_id, subject: [:name, :id])
    end

end