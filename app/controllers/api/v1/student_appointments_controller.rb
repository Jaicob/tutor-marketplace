class API::V1::StudentAppointmentsController < API::V1::Defaults
  before_action :set_student, except: [:visitor_create]
  before_action :restrict_to_resource_owner, except: [:visitor_create]
  before_action :set_appt, only: [:show, :reschedule, :cancel]

  def index
    @appts = @student.appointments
    respond_with(@appts)
  end

  def show
    respond_with(@appt)
  end

  def create
    appts = Appointment.create_appts_from_array(params)
    if appts
      render json: appts
    else
      render json: appts.errors.full_messages
    end
  end

  def visitor_create # creates appt without student_id, but adds it in next step when visitor must sign up
    appts = Appointment.visitor_create_appts_from_array(params)
    if appts
      render json: appts
    else
      render json: appts.errors.full_messages
    end
  end

  def reschedule
    if @appt.update(safe_params)
      AppointmentMailer.delay.appointment_rescheduled_for_tutor(@appt.id)
      AppointmentMailer.delay.appointment_rescheduled_for_student(@appt.id)
      render json: @appt
    else
      render json: @appt.errors.full_messages
    end
  end

  def cancel
    if @appt.update(safe_params)
      AppointmentMailer.delay.appointment_cancellation_for_tutor(@appt.id)
      AppointmentMailer.delay.appointment_cancellation_for_student(@appt.id)
      render json: @appt
    else
      render json: @appt.errors.full_messages
    end
  end

  private

    def set_student
      @student = Student.find(params[:student_id])
    end

    def set_appt
      @appt = Appointment.find(params[:id])
    end

    def restrict_to_resource_owner
      if current_user.nil? || current_user.student != @student
        return redirect_to restricted_access_path, status: 401
      end
    end

    def safe_params
      hash = {}
      hash[:student_id] = params[:student_id] if params[:student_id]
      hash[:slot_id] = params[:slot_id] if params[:slot_id]
      hash[:course_id] = params[:course_id] if params[:course_id]
      hash[:start_time] = params[:start_time] if params[:start_time]
      hash[:status] = params[:status] if params[:status]
      return hash
    end

end