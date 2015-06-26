class DashboardController < ApplicationController
	before_action :set_user
	before_action :set_tutor

	def home
	end

	def schedule
	end

	def courses
		@tutor_course = TutorCourse.new
	end

	def profile
	end

	# def change_profile_pic
	#   @tutor.update_attributes(profile_pic_params)
	#   redirect_to profile_user_path(@user)
	# end


	def save_profile_pic_crop
		@tutor.update_attributes(profile_pic_params)
		@tutor.crop_profile_pic
		redirect_to profile_user_path(@user)
	end

	def settings
	end

	# Admin actions below

	def tutors
		@tutors = Tutor.all
	end

	private

	def user_params
		params.require(:data).permit(user: [:first_name, :last_name, :email])
	end

	def tutor_params
		params.require(:data).permit(tutor: [:birthdate, :phone_number, :degree, :major, :extra_info, :graduation_year])
	end

	def profile_pic_params
		params.require(:profile_pic).permit(:profile_pic, :crop_x, :crop_y, :crop_w, :crop_h)
	end

end
