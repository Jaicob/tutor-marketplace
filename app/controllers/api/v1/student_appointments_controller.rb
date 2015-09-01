class API::V1::StudentAppointmentsController < API::V1::Defaults

  def index
    @appointments = Student.find(params[:student_id]).appointments
    respond_with(@appointments)
  end

end