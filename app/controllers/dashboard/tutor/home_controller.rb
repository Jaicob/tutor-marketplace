class Dashboard::Tutor::HomeController < DashboardController

  def index
  end

  def cancel_appt
    @appt = Appointment.find(params[:appt_id])
    if @appt.update_attribute('status', 'Cancelled')
      AppointmentMailer.delay.appointment_cancellation_for_tutor(@appt.id)               
      AppointmentMailer.delay.appointment_cancellation_for_student(@appt.id)
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
