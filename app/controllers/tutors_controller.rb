class TutorsController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy]
  before_action :set_tutor, only: [:show, :edit, :update, :destroy]

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

  def tutor_payment_info_form
    @tutor = Tutor.find(params[:id])
    respond_to do |format|
      format.js { render :load_payment_form }
    end
  end

  def update_tutor_payment_info
    @tutor = Tutor.find(params[:id])
    if @tutor.update_attributes(tutor_params)
      UpdateTutorAccount.call(tutor: @tutor, token: params[:stripeToken])
      respond_to do |format|
        format.js { render :payment_settings_updated }
        format.html { redirect_to dashboard_settings_payment_settings_user_path(@tutor.user) }
      end
    else
      respond_to do |format|
        format.js { render :load_payment_form }
        flash[:error] = "Something went wrong"
      end
    end
  end

  private

  def tutor_params
    params.require(:tutor).permit(:rating, :application_status, :appt_notes, :birthdate, :degree, :major, :extra_info, :graduation_year, :phone_number, :profile_pic, :transcript, :active_status, :crop_x, :crop_y, :crop_w, :crop_h, :line1, :line2, :city, :state, :postal_code, course: [:course_id], tutor_course: [:rate], user_attributes: [:first_name, :last_name, :email, :phone_number, :password, :password_confirmation])
  end

end