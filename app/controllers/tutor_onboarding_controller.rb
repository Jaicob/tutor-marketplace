class TutorOnboardingController < ApplicationController
  before_action :set_user
  before_action :set_tutor

  def application
  end

  def submit_application
    if @tutor.update(tutor_params)
      redirect_to onboarding_courses_tutor_path(@tutor.slug)
    else
      redirect_to :back
    end
  end

  def courses
    # refactor into model method
      step = @tutor.onboarding_status
      if step == 'Step 1'
        redirect_to onboarding_application_tutor_path(@tutor.slug)
      end
    # end of ship-it-fuck-it controller method
    @tutor_course = TutorCourse.new
  end

  def create_course
    @tutor_course = TutorCourse.create(tutor_course_params)
    if @tutor_course.save
      redirect_to onboarding_courses_tutor_path(@tutor.slug)
    else
      redirect_to :back
    end
  end

  def submit_courses
    if @tutor.update(tutor_params)
      redirect_to onboarding_schedule_tutor_path(@tutor.slug)
    else
      redirect_to :back
      # flash[:alert] = "Application was not submitted: #{@tutor.errors.full_messages.first}"
      # puts "Application was not submitted: #{@tutor.errors.full_messages}"
    end
  end

  def schedule
    # refactor into model method
      step = @tutor.onboarding_status
      if (step == 'Step 1') || (step == 'Step 2')
        redirect_to onboarding_courses_tutor_path(@tutor.slug)
      end
    # end of ship-it-fuck-it controller method
  end

  def submit_schedule
    @tutor.update(tutor_params)
    redirect_to payment_info_tutor_path(@tutor.slug)
    # success = redirect_to initial_banking_setup_path(@tutor.slug)
  end

  def payment_details
    # refactor into model method
      step = @tutor.onboarding_status
      if (step == 'Step 1') || (step == 'Step 2') || (step == 'Step 3')
        redirect_to onboarding_schedule_tutor_path(@tutor.slug)
      end
    # end of ship-it-fuck-it controller method
  end

  def submit_payment_details
    if @tutor.update(onboarding_status: 4)
      redirect_to home_tutor_path(@tutor.slug)
    else
      redirect_to :back
    end
  end

  private

    def tutor_params
      params.require(:tutor).permit(:onboarding_status, :school_id, :additional_degrees, :courses_approved, :rating, :application_status, :appt_notes, :birthdate, :degree, :major, :extra_info_1, :extra_info_2, :extra_info_3, :graduation_year, :phone_number, :profile_pic, :transcript, :active_status, :crop_x, :crop_y, :crop_w, :crop_h, :line1, :line2, :city, :state, :postal_code, :ssn_last_4, course: [:course_id], tutor_course: [:rate], user_attributes: [:first_name, :last_name, :email, :phone_number, :password, :password_confirmation])
    end

    def tutor_course_params
      params.require(:tutor_course).permit(:tutor_id, :course_id, :rate)
    end

end