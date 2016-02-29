class CheckoutController < ApplicationController
  before_action :set_tutor
  before_action :set_student
  before_action :set_school
  before_action :back_to_search, only: [:available_times]

  def select_course 
    # step 1
    # (view all courses a Tutor offers - bypassed from Search)
  end

  def set_course_id 
    # recieves step 1 input, saves it to session & redirects to step 2
    if params[:course_selection] && params[:course_selection][:course_id]
      session[:course_id] = params[:course_selection][:course_id]
    end
    session[:tutor_id] = @tutor.id
    if session[:course_id] == nil || session[:tutor_id] == nil
      redirect_to checkout_select_course_path(@tutor.slug, anchor: 'select-course')
      flash[:alert] = 'Please select a course'
    else
      redirect_to checkout_select_times_path(@tutor.slug, anchor: 'select-times')
    end
  end

  def select_times
    # step 2
    service = TutorAvailability.new(@tutor.id, params[:current], params[:week])
    @start_date = service.set_week
    @availability_data = service.get_times
    if session[:appt_info] && session[:tutor_id] == @tutor.id
      gon.selected_appt_ids = session[:appt_info].keys
    else
      gon.selected_appt_ids = nil
    end
  end

  def set_times 
    # recieves step 2 input, saves it to session & redirects to step 3
    session[:appt_info] = params[:appt_selection]
    if session[:appt_info] == nil
      redirect_to checkout_select_times_path(@tutor.slug, anchor: 'select-times')
      flash[:alert] = 'Please select a meeting time'
    else
      redirect_to checkout_select_location_path(@tutor.slug, anchor: 'set-location')
    end
  end

  def select_location 
    # step 3
    # - view page with input for setting location
  end

  def set_location
    # recieves step 3 input, saves it to session & redirects to step 4
    if params[:location_selection] && params[:location_selection][:location]
      session[:location] = params[:location_selection][:location]
    end
    if session[:location].blank?
      redirect_to checkout_select_location_path(@tutor.slug, anchor: 'set-location')
      flash[:alert] = 'Please enter a location preference'
    else
      redirect_to checkout_review_booking_path(@tutor.slug, anchor: 'review-booking')
    end
  end

  def review_booking
    if session[:location].blank?
      redirect_to checkout_select_course_path(@tutor.slug, anchor: 'select-course')
    end
    if @tutor.reviews.count < 3 
      session[:promo_code] = 'New Axon Tutor Auto-Discount'
    end
    # step 4, all booking information is set and shown to customer here
    # - if logged in, customer has option to use saved card (if one exists) or use a new card (with an option to save it)
    # - if NOT logged in, a customer has the option to sign in (moves to above step) or sign up and use a new card (with an option to save it)
    @booking_preview = BookingPreview.new(session, @tutor, current_user).format_info
    @booking_preview[:no_payment_due] == true ? (gon.free_session = true) : (gon.free_session = nil)
  end

  def apply_promo_code
    # recieves promo_code, tries to retrieve promotion and redirects back to review_booking page with success or failure message
    if session[:promo_code] == 'New Axon Tutor Auto-Discount'
      flash[:info] = "Only one promotion per checkout. The new Axon Tutor discount is already applied."
      redirect_to checkout_review_booking_path(@tutor.slug, anchor: 'review-booking')
      return
    end
    session[:promo_code] = params[:apply_promo_code][:code]
    preview = BookingPreview.new(session, @tutor, current_user).format_info
    if preview[:promo_data][:success] == true
      flash[:success] = "Promo code was succesfully applied!"
      redirect_to checkout_review_booking_path(@tutor.slug, anchor: 'review-booking')
    else
      flash[:alert] = preview[:promo_data][:error]
      redirect_to checkout_review_booking_path(@tutor.slug, anchor: 'review-booking')
    end
  end

  def process_booking
    @checkout_data = PrepareCheckout.new(params, session, @tutor, @student).prepare_data_for_checkout_organizer
    
    if @checkout_data[:success] == false
      # clean-up after failure - destroy new user if one was created
        if @checkout_data[:new_user?] == true
          User.find(@checkout_data[:new_user_id]).destroy
        end
      flash[:alert] = @checkout_data[:error]
      redirect_to checkout_review_booking_path(@tutor.slug, anchor: 'review-booking')
      return
    end
  
    @context = CheckoutOrganizer.call(@checkout_data)

    if @context.success?
      session[:charge_id] = @context.charge.id
      if @checkout_data[:new_user?] == true
        StudentManagementMailer.delay.welcome_email(@context.charge.student.user.id)
      end
      sign_in(@context.charge.student.user)
      redirect_to home_student_path(@context.charge.student, charge: @context.charge.id)
    else

      # for de-bugging CheckoutOrganizer, error details in server logs
        puts "Error Message     = #{@context.error}"
        puts "Error Type        = #{@context.error.class}"
        puts "Failed Interactor = #{@context.failed_interactor}"
      # end of error details

      # clean-up after failure - destroy new user if one was created
        if @checkout_data[:new_user?] == true
          User.find(@checkout_data[:new_user_id]).destroy
        end
      flash[:alert] = "Your booking was not processed: #{@context.error}"
      # flash[:alert] = 'Your booking was not processed due to a server error. You were not charged. Please try again and if you are still unable to complete your booking contact Axon at info@axontutors.com.'
      redirect_to checkout_review_booking_path(@tutor.slug, anchor: 'review-booking')
    end
  end

  private

    def set_tutor
      @tutor = Tutor.find(params[:id])
    end

    def back_to_search
      @from_search = true if request.referer && request.referer.split(/[^[:alpha:]]+/).include?('search')
    end

end