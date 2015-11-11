class Dashboard::Tutor::HomeController < DashboardController

  def index
  end

  def enter_personal_fields
  end

  def save_personal_fields
  end

  def enter_tutor_courses
  end

  def save_tutor_courses
  end

  def enter_availability
  end

  def save_availability
  end

  def enter_payment_info
  end

  def save_payment_info
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
