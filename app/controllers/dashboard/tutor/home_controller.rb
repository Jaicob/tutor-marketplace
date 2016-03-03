class Dashboard::Tutor::HomeController < DashboardController

  def index
    @recent_appointments = @tutor.appointments.order(start_time: :desc).select{|appt| appt.start_time < DateTime.now }.first(5)
    # @tutor_analyzer = TutorAnalyzer.new(@tutor)
  end

  def cancel_appt
    @appt = Appointment.find(params[:appt_id])
    if @appt.update_attribute('status', 'Cancelled')
      AppointmentMailer.delay.appointment_cancellation_for_tutor(@appt.id)               
      AppointmentMailer.delay.appointment_cancellation_for_student(@appt.id)
      refund_status = CancelledApptRefunder.new(@appt, current_user).issue_valid_refund
      flash[:info] = refund_status
      redirect_to home_tutor_path(@tutor.slug)
    else
      flash[:alert] = "Appointment was not updated: #{@appt.errors.full_messages.first}"
      redirect_to :back
    end
  end

  private 

    def appt_params
      params.require(:appointment).permit(:status)
    end

end
