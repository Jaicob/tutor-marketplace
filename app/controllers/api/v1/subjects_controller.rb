class API::V1::SubjectsController < API::V1::Defaults

  def index
    @school = School.find(params[:school_id])
    @subjects = @school.subjects
    respond_with(@subjects)
  end

  private

    def subject_params
      params.require(:subject).permit(:name)
    end

end