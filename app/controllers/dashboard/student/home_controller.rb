class Dashboard::Student::HomeController < DashboardController

  def cancel_appt
    @appt = Appointment.find(params[:appt_id])
    if @appt.update(appt_params)
      AppointmentMailer.delay.appointment_cancellation_for_tutor(@appt.id)               
      AppointmentMailer.delay.appointment_cancellation_for_student(@appt.id)
      redirect_to home_student_path(@student.slug)
    else
      redirect_to :back
    end
  end

  private 

    def appt_params
      params.require(:appointment).permit(:status)
    end

end
