class CheckoutController < ApplicationController
  before_action :set_tutor
  before_action :set_tutor_analyzer
  before_action :set_student
  before_action :set_school
  before_action :set_cart

  rescue_from StandardError do |e|
    if !request.original_url.include?('dockerhost') && !request.original_url.include?('staging')
      error_report = create_error_report(e)
      ProductionErrorMailer.delay.send_error_report(error_report)
    end
    session[:cart_id] = nil
    flash[:info] = "Uh oh! There was a network timeout. Please attempt your booking again. We apologize for the inconvenience."
    redirect_to checkout_select_course_path(@tutor.slug, anchor: 'select-course')
  end

  # step 1 - view
  def select_course 
    # step 1 (displays all courses a tutor offers - bypassed when coming from search)
  end

  # step 1 - saves input
  def set_course_id 
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

  # step 2 - view
  def select_times 
    # redirect to previous step if no times are in cart
    if @cart.info[:course_id].blank? || @cart.info[:tutor_id].blank?
      flash[:alert] = 'Please select a course'
      redirect_to checkout_select_course_path(@tutor.slug, anchor: 'select-course')
    end
    # everything here simply sets up calendar view
    data = TutorAvailability.new(@tutor.id, params[:current], params[:week]).get_times
    @start_date = data[:start_date]
    @times_for_week = data[:times_for_week]
    @future_availability = data[:future_availability]
    @zero_availability = data[:zero_availability]
    # set tutorID with Gon
    gon.tutor_id = @tutor.id
    # if any appt_times are already saved in cart, sets their ID's in Gon variable to let JS select them again
    if @cart.info[:appt_times] && @cart.info[:tutor_id] == @tutor.id
      gon.selected_appt_ids = @cart.info[:appt_times].keys
    else
      gon.selected_appt_ids = nil
    end
  end

  # step 2 - saves input via AJAX (except for middle condition - params[:regular_appt_selections] are submitted via standard form)
  def save_appt_time 
    # if no appt_times have been saved yet, the :app_times hash must first be instantiated
    if @cart.info[:appt_times].nil?
      @cart.info[:appt_times] = Hash.new
      @cart.info[:appt_times][params[:checkbox_id]] = params[:appt_times]
      @cart.save
    # if 1 or more appts are being added from the regular_times modal
    elsif params[:regular_appt_selections]
      appt_info_hash = params[:regular_appt_selections]
      appt_info_hash.each do |k,v|
        @cart.info[:appt_times][k] = v
      end
      if @cart.save
        appt_count = appt_info_hash.count
        flash[:info] = "#{appt_count} regular appointments were succesfully added to your cart."
      else
        flash[:info] = "Regular appointments were not added. Please try again."
      end
    # if the :app_times hash already exists and just one appt at a time is being saved via AJAX from select_times view
    else
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

  # this is the modal that pops up to encourage repeat regular bookings
  # uses special base layout view to load AJAX page (views/layouts/modal_only.html.erb)
  def regular_times 
    service = RegularApptScheduler.new(@tutor.id, params[:appt_info])
    @similar_appt_times = service.similar_appt_times
    @original_time = service.original_time
    @tutor 
    if @similar_appt_times.any?
      gon.similar_appts = @similar_appt_times.count
    else
      # if this is nil, then the reveal modal shouldn't open, needs to be done in JS on _available_times partial
      gon.similar_appts = nil 
    end
    # uses special layout view to load separate page w/o normal header and footer (views/layouts/modal_only.html.erb)
    render layout: "modal_only" 
  end

  # step 3 - view
  def select_location 
    # redirect to previous step if no times are in cart // this is also checked in above set_times step, but checking twice can't hurt, right? in case someone comes back to this page directly...
    if @cart.info[:appt_times].blank?
      flash[:info] = 'Please select a meeting time'
      redirect_to checkout_select_times_path(@tutor.slug, anchor: 'select-times')
    end
  end
  
  # step 3 - saves input
  def set_location 
    if params[:location_selection] && params[:location_selection][:location]
      @cart.info[:location] = params[:location_selection][:location]
      @cart.save
      redirect_to checkout_review_booking_path(@tutor.slug, anchor: 'review-booking')
    else
      redirect_to checkout_select_location_path(@tutor.slug, anchor: 'set-location')
    end
  end

  # step 4 - view
  def review_booking 
    # redirect to previous step if no location is in cart
    if @cart.info[:location].blank?
      flash[:info] = 'Please select a meeting time'
      redirect_to checkout_select_times_path(@tutor.slug, anchor: 'select-times')
    end
    # booking preview formats all booking info into summary for customer to view
    @booking_preview = BookingPreview.new(@cart, @tutor, current_user).format_info
    # :no_payment_due is a flag passed to JS via Gon variable to disable payment field for completely free bookings
    @booking_preview[:no_payment_due] == true ? (gon.free_session = true) : (gon.free_session = nil)
  end

  # step 4 - processes promo code
  def apply_promo_code 
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

  # step 5 - processes booking
  def process_booking 
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

    def start_over_for_missing_cart
      if session[:cart_id].nil?
        redirect_to redirect_to checkout_select_course_path(@tutor.slug, anchor: 'select-course')
        return
      end
    end

end