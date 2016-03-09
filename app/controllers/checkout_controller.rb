class CheckoutController < ApplicationController
  before_action :set_tutor
  before_action :set_tutor_analyzer
  before_action :set_student
  before_action :set_school
  before_action :set_cart

  def select_course
    # step 1 (displays all courses a Tutor offers - bypassed when coming from Search)
  end

  def set_course_id # recieves step 1 input, saves it to cart & redirects to step 2
    if params[:course_selection] && params[:course_selection][:course_id]
      if @cart.nil? # creates a new cart if a cart doesn't exist, if a cart does exist (for this session), it's set by the :set_cart before_action 
        @cart = Cart.create(info: Hash.new())
        session[:cart_id] = @cart.id
      end
      @cart.info[:course_id] = params[:course_selection][:course_id]
      @cart.info[:tutor_id] = @tutor.id
      @cart.save
      redirect_to checkout_select_times_path(@tutor.slug, anchor: 'select-times')
    else
      flash[:alert] = 'Please select a course'
      redirect_to checkout_select_course_path(@tutor.slug, anchor: 'select-course')
    end
  end

  def select_times
    # step 2
    service = TutorAvailability.new(@tutor.id, params[:current], params[:week])
    @start_date = service.set_week
    @availability_data = service.get_times
    if @cart.info[:appt_times] && @cart.info[:tutor_id] == @tutor.id
      gon.selected_appt_ids = @cart.info[:appt_times].keys
    else
      gon.selected_appt_ids = nil
    end
  end

  def appt_time
    if @cart.info[:appt_times].nil?
      @cart.info[:appt_times] = Hash.new
      @cart.info[:appt_times][params[:checkbox_id]] = params[:appt_times]
      @cart.save
    elsif params[:checkbox] == 'selected'
      @cart.info[:appt_times][params[:checkbox_id]] = params[:appt_times]
      @cart.save
    else 
      @cart.info[:appt_times] = @cart.info[:appt_times].to_hash.except!([params[:checkbox_id]].first)
      @cart.save
    end
    redirect_to checkout_select_times_path(@tutor.slug, anchor: 'select-times')
  end

  def set_times # this action originally accepted form data from select_times, but now that times are saved to the 'appt_info' session variable by AJAX, this action simply serves as a next step button with a redirect back when no times are selected
    if @cart.info[:appt_times] == nil # this one checks for appt_times on the cart rather than in the params, because times are saved to cart through AJAX
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

  def set_location # recieves step 3 input and saves it to cart, redirects to step 4 on success, back to step 3 on failure
    if params[:location_selection] && params[:location_selection][:location]
      @cart.info[:location] = params[:location_selection][:location]
      @cart.save
      redirect_to checkout_review_booking_path(@tutor.slug, anchor: 'review-booking')
    else
      redirect_to checkout_select_location_path(@tutor.slug, anchor: 'set-location')
    end
  end

  def review_booking # step 4, all booking information is set and shown to customer here
    # - if logged in, customer has option to use saved card (if one exists) or use a new card (with an option to save it)
    # - if NOT logged in, a customer has the option to sign in (moves to above step) or sign up and use a new card (with an option to save it)
    if TutorAnalyzer.new(@tutor).completed_appts.count < 3 
      @cart.info[:promo_code] = 'New Axon Tutor Auto-Discount'
    end
    @booking_preview = BookingPreview.new(@cart, @tutor, current_user).format_info
    @booking_preview[:no_payment_due] == true ? (gon.free_session = true) : (gon.free_session = nil)
  end

  def apply_promo_code # recieves promo_code, tries to retrieve promotion and redirects back to review_booking page with success or failure message
    if @cart.info[:promo_code] == 'New Axon Tutor Auto-Discount' # 
      flash[:info] = "Only one promotion per checkout. The new Axon Tutor discount is already applied."
      redirect_to checkout_review_booking_path(@tutor.slug, anchor: 'review-booking')
      return
    end
    @cart.info[:promo_code] = params[:apply_promo_code][:code]
    preview = BookingPreview.new(@cart, @tutor, current_user).format_info
    if preview[:promo_data][:success] == true
      flash[:success] = "Promo code was succesfully applied!"
      redirect_to checkout_review_booking_path(@tutor.slug, anchor: 'review-booking')
    else
      flash[:alert] = preview[:promo_data][:error]
      redirect_to checkout_review_booking_path(@tutor.slug, anchor: 'review-booking')
    end
  end

  def process_booking
    @checkout_data = PrepareCheckout.new(params, @cart, @tutor, @student).prepare_data_for_checkout_organizer

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
      @cart.info[:charge_id] = @context.charge.id
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

    def set_tutor_analyzer
      @tutor_analyzer = TutorAnalyzer.new(Tutor.find(params[:id]))
    end

    def set_cart
      if session[:cart_id]
        @cart = Cart.find(session[:cart_id])
      end
    end

end