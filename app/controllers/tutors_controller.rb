class TutorsController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy, :create_tutor_course]
  before_action :set_tutor, only: [:show, :edit, :update, :update_settings, :destroy, :create_tutor_course]
  before_action :set_tutor_for_admin_or_visitor_sign_up, only: [:register_or_sign_in, :visitor_sign_in, :visitor_sign_up, :update_active_status, :destroy_by_admin]

  # TUTOR CREATION IS HANDLED THROUGH THE DEVISE REGISTRATION CONTROLLER - ONE FORM CREATES USER AND TUTOR

  def show
  end

  def update
    @tutor.update(tutor_params)
    @tutor.crop_profile_pic(tutor_params)
    if @tutor.save
      redirect_to @tutor.update_action_redirect_path(tutor_params) # redirects to either settings or profile page
    else
      flash[:notice] = "Tutor was not updated: #{@tutor.errors.full_messages}"
      redirect_to :back
    end
  end

  def destroy
    if @tutor.destroy
      redirect_to dashboard_home_user_path(current_user)
    else
      flash[:alert] = "Your tutor account was not deleted."
      render :show
    end
  end

  private

    def tutor_params
      params.require(:tutor).permit(:rating, :application_status, :appt_notes, :birthdate, :degree, :major, :extra_info, :graduation_year, :phone_number, :profile_pic, :transcript, :active_status, :crop_x, :crop_y, :crop_w, :crop_h, course: [:course_id], tutor_course: [:rate], user_attributes: [:first_name, :last_name, :email, :phone_number, :password, :password_confirmation])
    end

end