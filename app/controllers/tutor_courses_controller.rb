class TutorCoursesController < ApplicationController

  def new
    @tutor_course = TutorCourse.new
  end

  def create
    @tutor_course = TutorCourse.create(tutor_course_params)

    if @tutor_course.save
      # @tutor_course.set_tutor_and_course_id(@tutor_course, params)
      redirect_to dashboard_courses_user_path(current_user)
    else
      flash[:notice] = "Tutor course was not created. Please try again."
      redirect_to :back
    end
  end

  def update
    @tutor_course = TutorCourse.find(params[:tutor_course_id])

    if @tutor_course.update_attributes(rate: params[:update_tutor_course_rate][:new_rate])
      redirect_to dashboard_courses_user_path(current_user)
    else
      flash[:error] = "Course was not edited."
    end

  end

  def destroy
    @tutor_course = TutorCourse.find(params[:id])
    tutor = @tutor_course.tutor
    @tutor_course.destroy
    redirect_to dashboard_courses_user_path(current_user)
  end


  private

    def tutor_course_params
      params.require(:tutor_course).permit(:course_id, :rate, :new_rate, :tutor_course_id)
    end


end
