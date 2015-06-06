class DashboardController < ApplicationController
  before_action :set_user
  before_action :set_tutor

  def home
  end

  def schedule
  end

  def courses
    @tutor = Tutor.find(params[:id])
    @tutor_course = TutorCourse.new
    @tutor_courses = @tutor.tutor_courses
  end

  def profile
    @profile_degree          = @tutor.degree
    @profile_major           = @tutor.major
    @profile_extra_info      = @tutor.extra_info
    @profile_graduation_year = @tutor.graduation_year
  end

  def apply_profile
    if @tutor.update_attributes(tutor_params)
      redirect_to profile_tutor_path(@tutor.id)
    else
      redirect_to profile_tutor_path(@tutor.id), notice: "Error saving changes."
    end
  end

  def settings
    @settings_name = @user.name
    @settings_email = @user.email
    @settings_birthdate = @tutor.birthdate
    @settings_phone_number = @tutor.phone_number
  end

  def apply_settings
    if @user.update_attributes(user_params) && @tutor.update_attributes(tutor_params)
      redirect_to settings_tutor_path(@tutor.id)
    else
      redirect_to settings_tutor_path(@tutor.id), notice: "Error saving changes."
    end
  end

  private

  def user_params
    params.require(:settings_data).permit(:name, :email)
  end

  def tutor_params
    params.require(:settings_data).permit(:birthdate, :phone_number, :degree, :major, :extra_info, :graduation_year)
  end

end
