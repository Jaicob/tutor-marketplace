class API::V1::SubjectsController < API::V1::Defaults

  def index
    @subjects = School.find(params[:school_id]).subjects
    respond_with(@subjects)
  end

end