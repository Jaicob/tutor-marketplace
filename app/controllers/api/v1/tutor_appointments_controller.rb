class API::V1::TutorAppointmentsController < API::V1::Defaults

  def index
    @appointments = Tutor.find(params[:tutor_id]).appointments
    respond_with(@appointments)
  end

  def create
    @appt = Appointment.new(appt_params)
    if @appt.save
      respond_with(@appt)
    else
      respond_with(status: 400)
    end
  end

  def show
    respond_with(@appt)
  end

  def update
    if @appt.update(appt_params)
      respond_with(@appt)
    else
      respong_with(status: 400)
    end
  end

  def destroy
    @appt.destroy
  end

  private

    def set_appt
      @appt = Appointment.find(params[:id])
    end
  
    def appt_params
      params.require(:appointment).permit(:student_id, :slot_id, :course_id, :start_time, :status)
    end

end