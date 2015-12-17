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
    if session[:appt_info] && TutorCourse.find(session[:tutor_course_id]).tutor_id == @tutor.id
      gon.selected_appt_ids = session[:appt_info].keys
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
    # recieves step 3 input, saves it to session & redirects to step 4
    session[:location] = params[:location_selection][:location]
    redirect_to checkout_payment_options_path(@tutor.slug)
  end

  def review_booking
    @booking_preview = BookingPreview.new(session).format_info
  end

  def process_booking
    @token = Stripe::Token.retrieve(params[:stripeToken])
    CheckoutRegistration.new(params, @tutor).create_student_user
    redirect_to checkout_confirmation_path
  end

  def confirmation # step 4
    @token = Stripe::Token.retrieve(params[:stripeToken])
    @booking_preview = BookingPreview.new(session).format_info
  end

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