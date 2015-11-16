class API::V1::PaymentsController < API::V1::Defaults
  before_action :set_student
  def check_student_for_customer_id
    @student = Student.find(params[:student_id])
    if @student
      render json: {
        full_name: @student.full_name,
        card: "#{@student.card_brand} **** #{@student.last_4_digits}",
        customer: @student.customer_id,
        success: true
      }
    else
      render json: {
        success: false
      }
    end
  end
end