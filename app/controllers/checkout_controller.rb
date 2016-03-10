class CheckoutController < ApplicationController
  before_action :set_tutor
  before_action :set_tutor_analyzer
  before_action :set_student
  before_action :set_school
  before_action :set_cart

  def select_course # step 1 - view
    # step 1 (displays all courses a tutor offers - bypassed when coming from search)
  end

  def set_course_id # step 1 - saves input
    if params[:course_selection] && params[:course_selection][:course_id]
      # creates a new cart if a cart doesn't exist (would only happen when a booking is started straight from a tutor's profile, rather than from search)
      # if a cart does exist (for this session), it's set by the :set_cart before_action 
      if @cart.nil? 
        @cart = Cart.create(info: Hash.new())
        session[:cart_id] = @cart.id
      end
      # saves course_id and tutor_id to cart
      @cart.info[:course_id] = params[:course_selection][:course_id]
      @cart.info[:tutor_id] = @tutor.id
      @cart.save
      # moves on to step 2
      redirect_to checkout_select_times_path(@tutor.slug, anchor: 'select-times')
    else
      # redirects back to step 1 if no course is chosen
      flash[:alert] = 'Please select a course'
      redirect_to checkout_select_course_path(@tutor.slug, anchor: 'select-course')
    end
  end

  def select_times # step 2 - view
    # everything here simply sets up calendar view
    data = TutorAvailability.new(@tutor.id, params[:current], params[:week]).get_times
    @start_date = data[:start_date]
    @times_for_week = data[:times_for_week]
    @future_availability = data[:future_availability]
    @zero_availability = data[:zero_availability]

    # if any appt_times are already saved in cart, sets their ID's in Gon variable to let JS select them again
    if @cart.info[:appt_times] && @cart.info[:tutor_id] == @tutor.id
      gon.selected_appt_ids = @cart.info[:appt_times].keys
    else
      gon.selected_appt_ids = nil
    end
  end

  def save_appt_time # step 2 - saves input via AJX
    # if no appt_times have been saved yet, the :app_times hash must first be instantiated
    if @cart.info[:appt_times].nil?
      @cart.info[:appt_times] = Hash.new
      @cart.info[:appt_times][params[:checkbox_id]] = params[:appt_times]
      @cart.save
    else
    # the :appt_times hash already exists
      # adds the appt_time if the time pill was selected
      if params[:checkbox] == 'selected'
        @cart.info[:appt_times][params[:checkbox_id]] = params[:appt_times]
        @cart.save
      # removes the appt_time if the time pill was de-selected
      else 
        @cart.info[:appt_times] = @cart.info[:appt_times].to_hash.except!([params[:checkbox_id]].first)
        @cart.save
      end
    end
    redirect_to checkout_select_times_path(@tutor.slug, anchor: 'select-times')
  end

  def regular_times
    @similar_appt_times = ['1','2','3']
    render layout: "modal_only"
  end

  def set_times # step 2 - checkpoint of sorts, makes sure 1+ appt_time is saved before reaching step 3
    if @cart.info[:appt_times] == nil 
      redirect_to checkout_select_times_path(@tutor.slug, anchor: 'select-times')
      flash[:alert] = 'Please select a meeting time'
    else
      redirect_to checkout_select_location_path(@tutor.slug, anchor: 'set-location')
    end
  end

  def select_location # step 3 - view
  end

  def set_location # step 3 - saves input
    if params[:location_selection] && params[:location_selection][:location]
      @cart.info[:location] = params[:location_selection][:location]
      @cart.save
      redirect_to checkout_review_booking_path(@tutor.slug, anchor: 'review-booking')
    else
      redirect_to checkout_select_location_path(@tutor.slug, anchor: 'set-location')
    end
  end

  def review_booking # step 4 - view
    # booking preview formats all booking info into summary for customer to view
    @booking_preview = BookingPreview.new(@cart, @tutor, current_user).format_info
    # :no_payment_due is a flag passed to JS via Gon variable to disable payment field for completely free bookings
    @booking_preview[:no_payment_due] == true ? (gon.free_session = true) : (gon.free_session = nil)
  end

  def apply_promo_code # step 4 - processes promo code
    if params[:apply_promo_code][:code]
      # save promo code to cart so it can be passed into BookingPreview service class
      @cart.info[:promo_code] = params[:apply_promo_code][:code]
      @cart.save
      # run BookingPreview service class to see if promo code is valid and can be redeemed
      preview = BookingPreview.new(@cart, @tutor, current_user).format_info
      if preview[:promo_data][:success] == true
        flash[:success] = "Promo code was succesfully applied!"
        redirect_to checkout_review_booking_path(@tutor.slug, anchor: 'review-booking')
      else
        flash[:alert] = preview[:promo_data][:error]
        redirect_to checkout_review_booking_path(@tutor.slug, anchor: 'review-booking')
      end
    end
  end

  def process_booking # step 5 - processes booking
    # PrepareCheckout service formats data for CheckoutOrganizer 
    # * flags if a new user is created so if CheckoutOrganizer fails, it knows to destroy user (so user can try to book and create account again with a new card, etc.)
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
    # CheckoutOrganizer service actually processes booking
    @context = CheckoutOrganizer.call(@checkout_data)
    if @context.success?
      # if booking is processed succesfully 
      @cart.info[:charge_id] = @context.charge.id
      if @checkout_data[:new_user?] == true
        StudentManagementMailer.delay.welcome_email(@context.charge.student.user.id)
      end
      sign_in(@context.charge.student.user)
      redirect_to home_student_path(@context.charge.student, charge: @context.charge.id)
    else
      # if booking is not processed succesfully 
      #  destroy new user if one was created
      if @checkout_data[:new_user?] == true
        User.find(@checkout_data[:new_user_id]).destroy
      end
      flash[:alert] = "Your booking was not processed: #{@context.error}"
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