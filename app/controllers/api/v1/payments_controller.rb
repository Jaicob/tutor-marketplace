class API::V1::PaymentsController < API::V1::Defaults
  before_action :set_student

  def current_student
    respond_with(@student)
  end

  private

  def set_student
    if current_user
      @student = current_user.student
    else
      @student = Student.new
    end
  end

end