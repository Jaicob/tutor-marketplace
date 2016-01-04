class TutorOnboardingController < ApplicationController
  before_action :set_user, except: [:create_existing_tutor_account]
  before_action :set_tutor, except: [:create_existing_tutor_account]
  before_action :set_tutor_course, only: [:update_course, :delete_course]

  helper OnboardingLinksHelper


  def application
  end

  def create_existing_tutor_account
    email = params[:existing_tutor][:email]
    password = params[:existing_tutor][:password]
    response = ExistingTutorOnboarding.new(email, password).create_user_and_tutor
    if response[:success] == true
      tutor = response[:tutor]
      sign_in_and_redirect(tutor.user)
    else
      flash[:error] = response[:error]
      redirect_to welcome_back_path
    end
  end

  def submit_application
    if @tutor.update(tutor_params)
      @tutor.update_onboarding_status(1)
      redirect_to onboarding_courses_tutor_path(@tutor.slug)
    else
      redirect_to :back
    end
  end

  def courses
    if @tutor.onboarding_status < 1
      redirect_to onboarding_application_tutor_path(@tutor.slug)
    end
    @tutor_course = TutorCourse.new
  end

  def create_course
    @tutor_course = TutorCourse.new(tutor_course_params)
    if @tutor_course.save
      redirect_to onboarding_courses_tutor_path(@tutor.slug)
    else
      redirect_to :back
      flash[:error] = "Course was not added to your course list!"
    end
  end

  def update_course
    @tutor_course.update(tutor_course_params)
    redirect_to onboarding_courses_tutor_path(@tutor.slug)
  end

  def delete_course
    @tutor_course.destroy
    redirect_to onboarding_courses_tutor_path(@tutor.slug)
  end

  def submit_courses
    @tutor.update(tutor_params)
    @tutor.update_onboarding_status(2)
    redirect_to onboarding_schedule_tutor_path(@tutor.slug)
  end

  def schedule
    if @tutor.onboarding_status < 2
      redirect_to onboarding_courses_tutor_path(@tutor.slug)
    end
  end

  def submit_schedule
    @tutor.update_onboarding_status(3)
    redirect_to onboarding_payment_details_tutor_path(@tutor.slug)
  end

  def payment_details
    if @tutor.onboarding_status < 3
      redirect_to onboarding_schedule_tutor_path(@tutor.slug)
    end
  end

  def submit_payment_details
    if @tutor.update_attributes(tutor_params)
      @tutor.update_attributes(last_4_acct: params[:last_4_acct])
      @tutor.update_onboarding_status(4)
      UpdateTutorAccount.call(tutor: @tutor, token: params[:stripeToken])
      respond_to do |format|
        format.js { render :payment_settings_updated }
        format.html { redirect_to home_tutor_path(@tutor.slug) }
      end
    else
      respond_to do |format|
        format.js { render :load_payment_form }
      end
    end
  end

  private

    def tutor_params
      params.require(:tutor).permit(:onboarding_status, :school_id, :additional_degrees, :courses_approved, :rating, :application_status, :appt_notes, :birthdate, :degree, :major, :extra_info_1, :extra_info_2, :extra_info_3, :graduation_year, :phone_number, :profile_pic, :transcript, :active_status, :crop_x, :crop_y, :crop_w, :crop_h, :line1, :line2, :city, :state, :postal_code, :ssn_last_4, course: [:course_id], tutor_course: [:rate], user_attributes: [:first_name, :last_name, :email, :phone_number, :password, :password_confirmation])
    end

    def tutor_course_params
      params.require(:tutor_course).permit(:tutor_id, :course_id, :rate)
    end

    def set_tutor_course
      @tutor_course = TutorCourse.find(params[:tutor_course_id])
    end

end