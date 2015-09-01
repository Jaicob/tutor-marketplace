class API::V1::TutorAppointmentsController < API::V1::Defaults

  def index
    @appointments = Tutor.find(params[:tutor_id]).appointments
    respond_with(@appointments)
  end

end