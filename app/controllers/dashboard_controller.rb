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

  def update_profile
    # The settings form updates two models, so the params for the User and Tutor models are nested inside the :data params hash and have to targeted below
    if @tutor.update_attributes(tutor_params[:tutor])
      redirect_to profile_user_path(@user.slug)
    else
      redirect_to profile_user_path(@user.slug), notice: "Error saving changes."
    end
  end

  def change_profile_pic
    @tutor.update_attributes(profile_pic_params)
    redirect_to profile_user_path(@user.slug)
  end

  def save_profile_pic_crop
    @tutor.update_attributes(profile_pic_params) 
    @tutor.crop_profile_pic
    redirect_to profile_user_path(@user.slug)
  end  

  def settings
  end

  def update_settings
    # The settings form updates two models, so the params for the User and Tutor models are nested inside the :data params hash and have to targeted below
    if @user.update(user_params[:user]) && @tutor.update(tutor_params[:tutor])
      redirect_to settings_user_path(@user)
    else
      redirect_to settings_user_path(@user), notice: "Error saving changes."
    end
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
