class TutorCoursesController < ApplicationController

	def find
		results = TutorCourse.where(
			tutor_id: params[:tutor_id],
			course_id: params[:course_id]
		)
		render json: results
	end

	def new
		@tutor_course = TutorCourse.new
	end

	def create
		@tutor_course = TutorCourse.create(tutor_course_params)
		@tutor_course.tutor_id = params[:tutor_course][:tutor_id]
		@tutor_course.course_id = params[:course][:course_id]
		# @tutor_course.set_tutor_and_course_id(@tutor_course, params)

		render json: @tutor_course

		if @tutor_course.save
			# redirect_to courses_user_path(current_user)
		else
			# render :new
		end
	end

	def update
		@tutor_course = TutorCourse.find(params[:id])

		if @tutor_course.update_attributes(rate: params[:new_rate])
			# redirect_to courses_user_path(current_user)
		else
			# flash[:error] = "Course was not edited."
		end

		render json: @tutor_course

	end

	def destroy
		TutorCourse.find(params[:id]).destroy
		render :nothing => true, :status => 200, :content_type => 'text/html'
		# redirect_to courses_user_path(current_user)
	end


	private

	def tutor_course_params
		params.require(:tutor_course).permit(:course_id, :rate, :new_rate, :tutor_course_id)
	end


end
