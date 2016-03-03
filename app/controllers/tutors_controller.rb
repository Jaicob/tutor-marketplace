class TutorsController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy]
  before_action :set_tutor, only: [:show, :update, :destroy]

  # TUTOR CREATION IS HANDLED THROUGH THE DEVISE REGISTRATION CONTROLLER - ONE FORM CREATES USER AND TUTOR

  def show
    if @tutor.active_status == 'Active'
      if params[:course]
        session[:course_id] = params[:course]
        redirect_to checkout_select_times_path(@tutor.slug)
      else
        redirect_to checkout_select_course_path(@tutor.slug)
      end
    end
  end

  def update
    if tutor_params[:school_id]
      if !@tutor.school_change_allowed?
        redirect_to :back
        flash[:alert] = "You cannot switch your campus with active course listings at your current campus."
        return
      else
        cookies[:school_id] = { value: tutor_params[:school_id], expires: 2.months.from_now }
      end
    end
    @tutor.update(tutor_params)
    @tutor.crop_profile_pic(tutor_params)
    if @tutor.save
      redirect_to @tutor.update_action_redirect_path(tutor_params) # redirects back to current page in settings
    else
      redirect_to :back
      flash[:alert] = "Your account was not updated: #{@tutor.errors.full_messages}"
    end
  end

  def destroy
    if @tutor.destroy
      redirect_to root_path
    else
      redirect_to :back
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
      @tutor.update_attributes(last_4_acct: params[:last_4_acct])

      @context = UpdateTutorAccount.call(tutor: @tutor, token: params[:stripeToken])

      if @context.failure?
        # for de-bugging CheckoutOrganizer, error details in server logs
          puts "Error Message     = #{@context.error}"
          puts "Error Type        = #{@context.error.class}"
          puts "Failed Interactor = #{@context.failed_interactor}"
        # end of error details
      end

      respond_to do |format|
        format.js { render :payment_settings_updated }
        format.html { redirect_to payment_info_tutor_path(@tutor.slug) }
      end
    else
      respond_to do |format|
        format.js { render :load_payment_form }
      end
    end
  end

  private

    def set_tutor
      @tutor = Tutor.find(params[:id]) #This is using the tutors ID, can user switch ti Tutor.find... or change the id being used - JS
    end

    def tutor_params
      params.require(:tutor).permit(:booking_buffer, :school_id, :additional_degrees, :courses_approved, :approval, :application_status, :appt_notes, :dob, :degree, :major, :extra_info_1, :extra_info_2, :extra_info_3, :graduation_year, :phone_number, :profile_pic, :transcript, :active_status, :crop_x, :crop_y, :crop_w, :crop_h, :line1, :line2, :city, :state, :postal_code, :ssn_last_4, course: [:course_id], tutor_course: [:rate], user_attributes: [:first_name, :last_name, :email, :phone_number, :password, :password_confirmation])
    end

end