class API::V1::SubjectsController < API::V1::Defaults

  def index
    @subjects = CourseSearchPopulater.new(params[:school_id]).subjects_with_active_tutors
    respond_with(@subjects)
  end

  def all_options
    @subjects = School.find(params[:school_id]).subjects
    respond_with(@subjects)
  end

end