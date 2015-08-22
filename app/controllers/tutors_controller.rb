class TutorsController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy, :create_tutor_course]
  before_action :set_tutor, only: [:show, :edit, :update, :update_settings, :destroy, :create_tutor_course]
  before_action :set_tutor_for_admin_or_visitor_sign_up, only: [:register_or_sign_in, :visitor_sign_in, :visitor_sign_up, :update_active_status, :destroy_by_admin]

  # TUTOR CREATION IS HANDLED THROUGH THE DEVISE CONTROLLERS - FORM CREATES USER AND TUTOR AT ONCE

  def show
  end

  def edit
  end

  def update
    @tutor.update(tutor_params)
    @tutor.crop_profile_pic(tutor_params)
    if @tutor.save
      redirect_to dashboard_profile_user_path(current_user)
    else
      flash[:notice] = "Tutor was not updated: #{@tutor.errors.full_messages}"
      redirect_to :back
    end
  end

  # THIS SHOULD NOT BE A SEPARATE ACTION - THE UPDATE ACTION SHOULD BE USED WITH A METHOD CALL THAT SHOULD CHECK WHAT WAS UPDATED AND REDIRECT TO THE APPROPRIATE PAGE BASED ON THAT
  # This is identical to the above Update action except that it redirects to the Dashboard Settings page rather than to a Tutor's profile. This action is used for updating a Tutor's birthdate and phone_number on the Dashboard Settings page.
  def update_settings
    @tutor.update(tutor_params)
    if @tutor.save
      redirect_to dashboard_settings_user_path(current_user)
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
      params.require(:tutor).permit(:rating, :application_status, :birthdate, :degree, :major, :extra_info, :graduation_year, :phone_number, :profile_pic, :transcript, :active_status, :crop_x, :crop_y, :crop_w, :crop_h, course: [:course_id], tutor_course: [:rate], user_attributes: [:first_name, :last_name, :email, :phone_number, :password, :password_confirmation])
    end

    def set_tutor_for_admin_or_visitor_sign_up
      @tutor = Tutor.find(params[:id])
    end

end