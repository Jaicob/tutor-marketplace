# class TutorCoursesController < ApplicationController
#   before_action :set_tutor_course, only: [:update, :destroy]

#   def create
#     @tutor_course = TutorCourse.create(tutor_course_params)
#     if @tutor_course.save
#       redirect_to dashboard_user_courses_path(current_user)
#     else
#       flash[:notice] = "Tutor course was not created: #{@tutor_course.errors.full_messages}"
#       redirect_to :back
#     end
#   end

#   def update
#     if @tutor_course.update(tutor_course_params)
#       redirect_to dashboard_user_courses_path(current_user)
#     else
#       flash[:notice] = "Tutor course was not edited: #{@tutor_course.errors.full_messages}"
#     end
#   end

#   def destroy
#     @tutor_course.destroy
#     redirect_to dashboard_user_courses_path(current_user)
#   end

#   private

#     def tutor_course_params
#       params.require(:tutor_course).permit(:tutor_id, :course_id, :rate)
#     end

#     def set_tutor_course
#       @tutor_course = TutorCourse.find(params[:id])
#     end

# end