class TutorOnboardingController < ApplicationController
  before_action :set_user, except: [:create_existing_tutor_account]
  before_action :set_tutor, except: [:create_existing_tutor_account]
  before_action :set_tutor_course, only: [:update_course, :delete_course]

  helper OnboardingLinksHelper

  def application
    @tutor.major.blank? ? gon.missing_education = true : gon.missing_education = false
    @tutor.extra_info_1.blank? ? gon.missing_statements = true : gon.missing_statements = false
    @tutor.transcript.file.nil? ? gon.missing_transcript = true : gon.missing_transcript = false
    @tutor.profile_pic.file.nil? ? gon.missing_profile_pic = true : gon.missing_profile_pic = false
  end

  def save_profile_section
    if @tutor.update(tutor_params)
      if tutor_params.include?(:profile_pic) || tutor_params.include?(:transcript)
        redirect_to onboarding_application_tutor_path(@tutor, anchor: 'files')
      else
        redirect_to :back
      end
    else
      flash[:error] = 'Information was not saved. Please try again.' 
      redirect_to :back
    end
  end

  def submit_finished_profile
    @tutor.update_onboarding_status(1)
    redirect_to onboarding_courses_tutor_path(@tutor.slug)
  end

  def courses
    @all_options_for_tutor = true
    if @tutor.onboarding_status < 1
      redirect_to onboarding_application_tutor_path(@tutor.slug)
    end
    @tutor_course = TutorCourse.new
  end

  def create_course
    @tutor_course = TutorCourse.new(tutor_course_params)
    if @tutor_course.save
      redirect_to onboarding_courses_tutor_path(@tutor.slug, anchor: 'my-courses')
    else
      redirect_to :back
      flash[:error] = "Course was not added to your course list!"
    end
  end

  def update_course
    @tutor_course.update(tutor_course_params)
    redirect_to onboarding_courses_tutor_path(@tutor.slug, anchor: 'my-courses')
  end

  def delete_course
    @tutor_course.destroy
    redirect_to onboarding_courses_tutor_path(@tutor.slug, anchor: 'my-courses')
  end

  def submit_courses
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
    if @tutor.update(tutor_params)
      @tutor.update(last_4_acct: params[:last_4_acct])
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
      params.require(:tutor).permit(:onboarding_status, :school_id, :additional_degrees, :courses_approved, :rating, :application_status, :appt_notes, :dob, :degree, :major, :extra_info_1, :extra_info_2, :extra_info_3, :graduation_year, :phone_number, :profile_pic, :transcript, :active_status, :crop_x, :crop_y, :crop_w, :crop_h, :line1, :line2, :city, :state, :postal_code, :ssn_last_4, course: [:course_id], tutor_course: [:rate], user_attributes: [:first_name, :last_name, :email, :phone_number, :password, :password_confirmation])
    end

    def tutor_course_params
      params.require(:tutor_course).permit(:tutor_id, :course_id, :rate)
    end

    def set_tutor_course
      @tutor_course = TutorCourse.find(params[:tutor_course_id])
    end

end