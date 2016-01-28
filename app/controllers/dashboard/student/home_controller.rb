class Dashboard::Student::HomeController < DashboardController
  before_action :set_appt, only: [:view_reschedule_options, :reschedule_appt]

  def index
    if params[:charge]
      @charge = Charge.find(params[:charge])
      @booking_preview = BookingPreview.new(session, @charge.tutor).format_info
      @charge = Charge.find(session[:charge_id])
      if @booking_preview[:no_payment_due] != true
        @card_info = Processor::Stripe.new.get_charge_details(@charge.stripe_charge_id)
      end
      delete_all_session_variables
    end
  end

  def cancel_appt
    @appt = Appointment.find(params[:appt_id])
    if @appt.update_attribute('status', 'Cancelled')
      AppointmentMailer.delay.appointment_cancellation_for_tutor(@appt.id)               
      AppointmentMailer.delay.appointment_cancellation_for_student(@appt.id)
      redirect_to home_student_path(@student)
    else
      flash[:alert] = "Appointment was not cancelled: #{@appt.errors.full_messages.first}"
      redirect_to :back
    end
  end

  # view_reschedule_options_student_path
  def view_reschedule_options
    service = TutorAvailability.new(@appt.tutor.id, params[:current], params[:week])
    @start_date = service.set_week
    @availability_data = service.get_times
    gon.selected_appt_ids = nil
  end

  # reschedule_appt_student_path
  def reschedule_appt
    response = ApptRescheduler.new(@appt.id, params).reschedule_appt
    if response[:success] == true
      redirect_to home_student_path(@student)
      flash[:success] = 'Your appointment was successfully rescheduled'
    else
      redirect_to :back
      flash[:alert] = "Your appointment was not rescheduled: #{response[:error]}"
    end
  end
                                 

  private 

    def appt_params
      params.require(:appointment).permit(:status)
    end

    def set_appt
      @appt = Appointment.find(params[:appt_id])
    end

    def delete_all_session_variables
      session[:course_id] = nil
      session[:appt_info] = nil
      session[:location] = nil
      session[:charge_id] = nil
      session[:promo_code] = nil
    end

end