class CheckoutController < ApplicationController
  before_action :set_tutor
  before_action :back_to_search, only: [:available_times]

  def select_course # step 1
   # (view all courses a Tutor offers - bypassed from Search)
  end

  def set_course_id
    session[:tutor_course_id] = params[:course_selection][:tutor_course_id]
    redirect_to checkout_select_times_path(@tutor.slug)
  end

  def select_times # step 2
    @tutor_course = TutorCourse.find(session[:tutor_course_id])
    service = TutorAvailability.new(@tutor.id, params[:current], params[:week])
    @start_date = service.set_week
    @availability_data = service.get_times
  end

  def set_appt_times
    session[:appts_info] = params[:appt_selection]
    redirect_to checkout_select_location_path(@tutor.slug)
  end

  def select_location # step 3
   # (view page with input for setting location)
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

end


    # get '/course_list'       => 'checkout#select_course', as: 'checkout_select_course'
    # get '/available_times'   => 'checkout#select_times', as: 'checkout_select_times'
    # get '/set_location'      => 'checkout#select_location', as: 'checkout_select_location'
    # get '/confirmation'      => 'checkout#confirmation', as: 'checkout_confirmation'
    # get '/summary'           => 'checkout#summary', as: 'checkout_summary'