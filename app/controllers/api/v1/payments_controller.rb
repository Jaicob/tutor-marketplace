class API::V1::PaymentsController < API::V1::Defaults
  before_action :set_student

  def current_student
    respond_with(@student)
    puts @student.to_json
  end

  private

  def set_student
    @student = current_user.student
  end

end