class API::V1::TutorCoursesController < API::V1::Defaults
  before_action :set_tutor

  def index
    @tutor_courses = @tutor.course_list
    respond_with(@tutor_courses)
  end

  private

    def set_tutor
      @tutor = Tutor.find(params[:tutor_id])
    end

end