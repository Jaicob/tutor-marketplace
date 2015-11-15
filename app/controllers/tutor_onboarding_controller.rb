class TutorOnboardingController < ApplicationController
  before_action :set_tutor

  def application
  end

  def submit_application
    if @tutor.update(tutor_params)
      redirect_to onboarding_courses_path(@tutor.slug)
    else
      redirect_to :back
      # flash[:alert] = "Application was not submitted: #{@tutor.errors.full_messages.first}"
      # puts "Application was not submitted: #{@tutor.errors.full_messages}"
    end
  end

  def courses
  end

  def submit_courses
    if @tutor.update(tutor_params)
      redirect_to onboarding_schedule_path(@tutor.slug)
    else
      redirect_to :back
      # flash[:alert] = "Application was not submitted: #{@tutor.errors.full_messages.first}"
      # puts "Application was not submitted: #{@tutor.errors.full_messages}"
    end
  end

  def schedule
  end

  def submit_schedule
    @tutor.update(tutor_params)
    redirect_to payment_info_tutor_path(@tutor.slug)
    # success = redirect_to initial_banking_setup_path(@tutor.slug)
  end

  def payment_details
  end

  def submit_payment_details
    @tutor.update(onboarding_status: 4)
    # success = redirect_to home_tutor_path(@tutor.slug)
  end

  private

    def tutor_params
      params.require(:tutor).permit(:onboarding_status, :school_id, :additional_degrees, :courses_approved, :rating, :application_status, :appt_notes, :birthdate, :degree, :major, :extra_info_1, :extra_info_2, :extra_info_3, :graduation_year, :phone_number, :profile_pic, :transcript, :active_status, :crop_x, :crop_y, :crop_w, :crop_h, :line1, :line2, :city, :state, :postal_code, :ssn_last_4, course: [:course_id], tutor_course: [:rate], user_attributes: [:first_name, :last_name, :email, :phone_number, :password, :password_confirmation])
    end

end