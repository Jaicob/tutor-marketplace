class Admin::AppointmentsController < AdminController
  before_action :set_appt, only: [:show, :update, :destroy]

  def search
    index
    render :index
  end

  def index
    @q = current_user.admin_scope(:appointments).ransack(params[:q])
    @appointments = @q.result.includes(:slot, :student, :course)
  end

  def show
  end

  def update
    @appt.update(appt_params)
    if @appt.save
      AppointmentMailer.delay.appointment_rescheduled_for_tutor(@appt.id)               
      AppointmentMailer.delay.appointment_rescheduled_for_student(@appt.id)
      flash[:notice] = "Appointment was succesfully updated."
      redirect_to :back
    else
      flash[:error] = "Appointment was not updated."
      render :show
    end
  end

  private

    def set_appt
      @appt = Appointment.find(params[:id])
    end

    def appt_params
      params.require(:appointment).permit(:student_id, :slot_id, :course_id, :start_time, :status)
    end
  
end