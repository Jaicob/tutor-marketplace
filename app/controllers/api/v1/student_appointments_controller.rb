class API::V1::StudentAppointmentsController < API::V1::Defaults
  before_filter :find_appointment, only: [:show, :update]

  before_filter only: :create do
    unless @json.has_key?('appointment') && @json['appointment'].responds_to?(:[]) && @json['appointment']['name']
      render nothing: true, status: :bad_request
    end
  end

  before_filter only: :update do
    unless @json.has_key?('appointment')
      render nothing: true, status: :bad_request
    end
  end

  before_filter only: :create do
    @appointment = Appointment.find_by_name(@json['appointment']['name'])
  end

  def index
    @appointments = Student.find(params[:student_id]).appointments
    respond_with(@appointments)
  end

  def show
    respond_with(@appointment)
  end

  def create
    if @appointment.present?
      render nothing: true, status: :conflict
    else
      @appointment = Appointment.new
      @appointment.assign_attributes(@json['appointment'])
      if @appointment.save
        render json: @appointment
      else
         render nothing: true, status: :bad_request
      end
    end
  end

  def update
    @appointment.assign_attributes(@json['appointment'])
    if @appointment.save
        render json: @appointment
    else
        render nothing: true, status: :bad_request
    end
  end

 private
   def find_appointment
     @appointment = Appointment.find(params[:id])
   end

end