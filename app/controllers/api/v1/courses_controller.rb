class API::V1::CoursesController < API::V1::Defaults

  def index
    @school = School.find(params[:school_id])
    @courses = @school.courses.find_all do |course|
      course.subject_id == params[:subject_id].to_i
    end
    respond_with(@courses)
  end

end