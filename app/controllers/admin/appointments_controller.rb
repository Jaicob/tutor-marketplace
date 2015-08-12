class Admin::AppointmentsController < AdminController

  def search
    index
    render :index
  end

  def index
    @q = Appointment.ransack(params[:q])
    @appointments = @q.result.includes(:slot, :student, :course)
  end

  def show
    @appt = Appointment.find(params[:id])
  end
  
end