class API::V1::StudentAppointmentsController < API::V1::Defaults
  before_action :set_student
  before_action :restrict_to_resource_owner
  before_action :set_appointment, only: [:show, :update, :destroy]

  def index
    @appointments = @student.appointments
    respond_with(@appointments)
  end

  def show
    respond_with(@appointment)
  end

  def create
    @appointment = Appointment.new
    @appointment.assign_attributes(safe_params)
    if @appointment.save
      render json: @appointment
    else
      render nothing: true, status: 400
    end
  end

  def update
    @appointment.assign_attributes(safe_params)
    if @appointment.save
      render json: @appointment
    else
      render nothing: true, status: 400
    end
  end

  def destroy
    if @appointment.destroy
      render nothing: true, status: 200
    else
      render nothing: true, status: 500
    end
  end

  private

    def set_student
      @student = Student.find(params[:student_id])
    end

    def set_appointment
      @appointment = Appointment.find(params[:id])
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

    def restrict_to_resource_owner
      if current_user.nil? || current_user.student != @student
        return redirect_to restricted_access_path, status: 401
      end
    end  

end