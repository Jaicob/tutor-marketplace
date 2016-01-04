class Dashboard::Tutor::HomeController < DashboardController

  def index
    puts "current_user = #{current_user}"
    puts "current_user.tutor = #{current_user.tutor}"
    puts "current_user.tutor.id  = #{current_user.tutor.id}"
    puts "@tutor = #{@tutor}"
    puts "current_user.tutor.application_status = #{current_user.tutor.application_status}"
  end

  def cancel_appt
    @appt = Appointment.find(params[:appt_id])
    if @appt.update(appt_params)
      AppointmentMailer.delay.appointment_cancellation_for_tutor(@appt.id)               
      AppointmentMailer.delay.appointment_cancellation_for_student(@appt.id)
      redirect_to home_tutor_path(@tutor.slug)
    else
      redirect_to :back
    end
  end

  private 

    def appt_params
      params.require(:appointment).permit(:status)
    end

end
