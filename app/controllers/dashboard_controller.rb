class DashboardController < ApplicationController
  before_action :set_user
  before_action :set_tutor

  def home
  end

  def schedule
  end

  def courses
    friendly_id_to_user_id
    friendly_id_to_tutor_id
    @tutor_course = TutorCourse.new
    @tutor_courses = @tutor.tutor_courses
  end

  def profile
  end

  def update_profile
    if @tutor.update_attributes(tutor_params)
      redirect_to profile_user_path(@user.id)
    else
      redirect_to profile_user_path(@user.id), notice: "Error saving changes."
    end
  end

  def change_profile_pic
    @tutor.update_attributes(profile_pic_params)
    redirect_to profile_user_path(@user.id)
  end

  def crop_profile_pic 
    @tutor.update_attributes(profile_pic_params) 
    @tutor.crop_profile_pic
    flash[:notice] = "Successfully updated Image."  
    redirect_to profile_user_path(@user.id)
  end  

  def settings
  end

  def update_settings
    if @user.update_attributes(user_params) && @tutor.update_attributes(tutor_params)
      redirect_to settings_user_path(@user.id)
    else
      redirect_to settings_user_path(@user.id), notice: "Error saving changes."
    end
  end

  private

    def user_params
      params.require(:settings_data).permit(:name, :email)
    end

    def tutor_params
      params.require(:profile_data).permit(:birthdate, :phone_number, :degree, :major, :extra_info, :graduation_year, :profile_pic)
    end

    def profile_pic_params
      params.require(:profile_pic).permit(:profile_pic, :crop_x, :crop_y, :crop_w, :crop_h)
    end
    
    def friendly_id_to_user_id
      @user = User.friendly.find(params[:id])
    end

    def friendly_id_to_tutor_id
      @user.tutor
    end

end
