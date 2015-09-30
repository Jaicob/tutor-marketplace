class API::V1::PaymentsController < API::V1::Defaults
  before_action :set_student

  def method_name

  end

  private

  def set_student
    @student = current_user.student || Student.new
  end

end