class API::V1::TutorAppointmentsController < API::V1::Defaults
  before_action :set_tutor
  before_action :restrict_to_resource_owner, except: [:index]
  before_filter :set_appointment, only: [:show, :cancel]

  def index
    @appointments = @tutor.restricted_appointments_info(@tutor, current_user)
    respond_with(@appointments)
  end

  def show
    respond_with(@appointment)
  end

  def cancel
    if @appointment.update(safe_params)
      render json: @appointment
    else
      render json: @appointment.errors.full_messages
    end
  end

  private

    def set_tutor
      @tutor = Tutor.find(params[:tutor_id])
    end

    def set_appointment
      @appointment = Appointment.find(params[:id])
    end

    def restrict_to_resource_owner
      if current_user.nil? || current_user.tutor != @tutor
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