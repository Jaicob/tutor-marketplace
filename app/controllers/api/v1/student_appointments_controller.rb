class API::V1::StudentAppointmentsController < API::V1::Defaults
  before_action :set_student
  before_action :restrict_to_resource_owner
  before_action :set_appt, only: [:show, :reschedule, :cancel]

  def index
    @appts = @student.appointments
    respond_with(@appts)
  end

  def show
    respond_with(@appt)
  end

  def create
    @appt = Appointment.new
    @appt.update(safe_params)
    if @appt.save
      ProcessPayment.call(
        tutor: @appt.tutor,
        appointments: [@appt],
        customer_id: 
      )

# params = {
#   tutor: Tutor.find(23),
#   appointments: [Appointment.first],
#   customer_id: Student.find(22).customer_id,
#   rates: [23],
#   transaction_percentage: 15.0,
#   promotion_id: @promotion.id,
#   is_payment_required: true,
# }

#  id         :integer          not null, primary key
#  student_id :integer
#  slot_id    :integer
#  course_id  :integer
#  start_time :datetime
#  status     :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  charge_id  :integer
#
  # delegate :tutor, to: :slot
  # delegate :school, to: :course


      # AppointmentMailer.delay.appointment_confirmation_for_tutor(@appt.id)
      # AppointmentMailer.delay.appointment_confirmation_for_student(@appt.id)
      # if @appt.appt_reminder_email_date != nil
      #   ApptReminderWorker.perform_at(@appt.appt_reminder_email_date, @appt.id)
      #   ApptReminderWorker.perform_at(@appt.appt_reminder_email_date, @appt.id)
      # end
      render json: @appt
    else
      render nothing: true, status: 500
    end
  end

  def reschedule
    if @appt.update(safe_params)
      AppointmentMailer.delay.appointment_rescheduled_for_tutor(@appt.id)               
      AppointmentMailer.delay.appointment_rescheduled_for_student(@appt.id)
      render json: @appt
    else
      render nothing: true, status: 500
    end
  end

  def cancel
    if @appt.update(safe_params)
      AppointmentMailer.delay.appointment_cancellation_for_tutor(@appt.id)               
      AppointmentMailer.delay.appointment_cancellation_for_student(@appt.id)
      render json: @appt
    else
      render nothing: true, status: 500
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