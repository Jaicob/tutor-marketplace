class TutorCoursesController < ApplicationController

  def new
    @tutor_course = TutorCourse.new
  end

  def create
    @tutor_course = TutorCourse.create(tutor_course_params)
    @tutor_course.create_tutor
    @tutor_course.tutor.attach_transcript(@tutor_course.tutor, params)
    @tutor_course.set_courses(@tutor_course, params)

    if @tutor_course.save
      redirect_to root_path
    else
      render :new
    end

  end


  private

    def tutor_course_params
      params.require(:tutor_course).permit(:rate)
    end


end
