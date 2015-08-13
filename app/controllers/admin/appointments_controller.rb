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


# class CampusManager::AppointmentsController < CampusManagerController
#   before_action :set_appt, only: [:show, :update, :destroy]

#   def search
#     index
#     render :index
#   end

#   def index
#     @q = @school.appointments.ransack(params[:q])
#     @appointments = @q.result.includes(:slot, :student, :course)
#   end

#   def new
#   end

#   def show
#   end

#   def update
#     @appt.update(appt_params)
#     if @appt.save
#       redirect_to campus_manager_school_appointment_path(@appt.school.id, @appt.id)
#     else
#       flash[:error] = "Appointment was not updated."
#       render :show
#     end
#   end

#   private

#     def appt_params
#       params.require(:appointment).permit(:student_id, :slot_id, :course_id, :start_time, :status)
#     end

#     def set_appt
#       @appt = Appointment.find(params[:id])
#     end
  
# end