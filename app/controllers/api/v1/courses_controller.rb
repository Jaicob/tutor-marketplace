class API::V1::CoursesController < API::V1::Defaults

  def index
    @courses = School.find(params[:school_id]).courses_for_subject(params[:subject_id])
    respond_with(@courses)
  end

end