class CheckoutController < ApplicationController
  before_action :set_tutor
  before_action :back_to_search, only: [:available_times]
  before_action :appointments_preview, only: [:login_or_signup, :confirmation]

  def select_course 
    # step 1
    # (view all courses a Tutor offers - bypassed from Search)
  end

  def set_course_id 
    # recieves step 1 input, saves it to session & redirects to step 2
    session[:tutor_course_id] = params[:course_selection][:tutor_course_id]
    redirect_to checkout_select_times_path(@tutor.slug)
  end

  def select_times 
    # step 2
    @tutor_course = TutorCourse.find(session[:tutor_course_id])
    service = TutorAvailability.new(@tutor.id, params[:current], params[:week])
    @start_date = service.set_week
    @availability_data = service.get_times
    if session[:appt_info]
      gon.selected_appt_ids = session[:appt_info].keys
      # @selected_appt_ids = session[:appt_info].keys
      # gon.selected_appt_ids = @selected_appt_ids
    end
  end

  def set_times 
    # recieves step 2 input, saves it to session & redirects to step 3
    session[:appt_info] = params[:appt_selection]
    redirect_to checkout_select_location_path(@tutor.slug)
  end

  def select_location # step 3
   # (view page with input for setting location)
  end

  def set_location
    # recieves step 3 input, saves it to session & redirects to step 4 (checkout - but branches based on logged in or not)
    session[:location] = params[:location_selection][:location]
    if current_user
      redirect_to confirmation_path
    else
      redirect_to checkout_login_or_signup_path
    end
  end

  def login_or_signup
  end

  def confirmation # step 4
   # (view two options - sign_up or sign_in - bypassed if already logged in)
  end

  def summary # step 5
   # (view checkout details - 'Your Booking' - plus field for Promo codes)
  end

  # def set_school_id_cookie
  #   session[:checkout_step] = 1
  # end

  private

    def set_tutor
      @tutor = User.find(params[:id]).tutor
    end

    def back_to_search
      @from_search = true if request.referer && request.referer.split(/[^[:alpha:]]+/).include?('search')
    end

    def appointments_preview
      @appt_preview = Appointment.build_preview(session)
    end

end