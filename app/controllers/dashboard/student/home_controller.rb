class Dashboard::Student::HomeController < DashboardController
  before_action :set_appt, only: [:view_reschedule_options, :confirm_reschedule, :reschedule_appt]

  def index
    @recent_appointments = @student.appointments.order(start_time: :desc).select{|appt| appt.start_time < DateTime.now }.first(5)
    if params[:charge]
      @charge = Charge.find(params[:charge])
      @cart = Cart.find(session[:cart_id])
      @receipt_only = true # this is only set in the Student Dashboard controller home action when a receipt is diplayed, flag is necessary to bypass validations (because after the checkout has been completed a StudentsPromotions record exists and if promo is a no_repeat type then it won't pass the validation and display the formatted prices correctly)
      @booking_preview = BookingPreview.new(@cart, @charge.tutor, current_user, @receipt_only).format_info
      if @booking_preview[:no_payment_due] != true
        @card_info = Processor::Stripe.new.get_charge_details(@charge.stripe_charge_id)
      end
    end
    if ApptReviewCreator.new(@student).reviews_needed?
      @reviews_needed = true
      @appts_to_review = ApptReviewCreator.new(@student).format_appts_to_review
    end
  end

  def submit_appt_reviews
    if params[:appt_reviews]
      response = ApptReviewCreator.new(@student, params).create_reviews
    end
    redirect_to home_student_path(@student)
  end

  def cancel_appt
    @appt = Appointment.find(params[:appt_id])
    if @appt.update_attribute('status', 'Cancelled')
      AppointmentMailer.delay.appointment_cancellation_for_tutor(@appt.id)
      AppointmentMailer.delay.appointment_cancellation_for_student(@appt.id)
      refund_status = CancelledApptRefunder.new(@appt, current_user).issue_valid_refund
      flash[:info] = refund_status
      redirect_to home_student_path(@student)
    else
      flash[:alert] = "Appointment was not cancelled: #{@appt.errors.full_messages.first}"
      redirect_to :back
    end
  end

  # view_reschedule_options_student_path
  def view_reschedule_options
    if @appt.no_reschedule_allowed?
      flash[:info] = 'Due to our 24-hour policy, this appointment can no longer be rescheduled.'
      redirect_to :back
      return
    end
    data = TutorAvailability.new(@appt.tutor.id, params[:current], params[:week]).get_times
    @start_date = data[:start_date]
    @times_for_week = data[:times_for_week]
    # @future_availability is boolean which determines whether or not 'Next Week' button should be disabled
    @future_availability = data[:future_availability]
    gon.student_id = @student.id
    gon.appt_id = @appt.id
  end

  # modal that displays selected time and old time + asks for confirmation to reschedule
  def confirm_reschedule
    reschedule = ApptRescheduler.new(@appt.id, params).format_new_time
    if reschedule[:success] == true
      @new_start_time = reschedule[:new_start_time]
      @new_slot_id = reschedule[:new_slot_id]
    end
    render layout: '../dashboard/student/home/confirm_reschedule'
  end

  # reschedule_appt_student_path
  def reschedule_appt
    response = ApptRescheduler.new(@appt.id, params).reschedule_appt
    if response[:success] == true
      flash[:success] = 'Your appointment was successfully rescheduled'
      redirect_to home_student_path(@student)
    else
      flash[:alert] = "Your appointment was not rescheduled: #{response[:error]}"
      if response[:error_type] = '24-hour-policy'
        redirect_to home_student_path(@student)
      else
        redirect_to :back
      end
    end
  end

  private

  def appt_params
    params.require(:appointment).permit(:status)
  end

  def set_appt
    @appt = Appointment.find(params[:appt_id])
  end

end
