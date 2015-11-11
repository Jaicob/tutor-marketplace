class Dashboard::Tutor::ScheduleController < DashboardController

  def index
  end

  def cancel_appt
    @appt = Appointment.find(params[:appt_id])
    if @appt.update(appt_params)
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
