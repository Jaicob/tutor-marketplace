class API::V1::CoursesController < API::V1::Defaults

  def index
    @courses = CourseSearchPopulater.new(params[:school_id], params[:subject_id]).courses_with_active_tutors
    respond_with(@courses)
  end

  def all_options
    @courses = School.find(params[:school_id]).courses_for_subject(params[:subject_id])
    respond_with(@courses)
  end

end