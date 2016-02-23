class Dashboard::Admin::AppointmentsController < AdminController
  before_action :set_appt, only: [:show, :update, :destroy]
  before_action :set_review, only: [:show]

  def search
    index
    render :index
  end

  def index
    @q = current_user.admin_scope(:appointments).ransack(params[:q])
    @appointments = @q.result.includes(:slot, :student, :course).page(params[:page])
  end

  def show
    @charge = @appt.charge
  end

  def update
    @appt.update(appt_params)
    if @appt.save
      @appt.send_update_or_cancel_appt_email(@appt.id, appt_params)
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

    def set_review
      if @appt.review
        @review = @appt.review
      end
    end

    def appt_params
      params.require(:appointment).permit(:student_id, :slot_id, :course_id, :start_time, :status)
    end
end
