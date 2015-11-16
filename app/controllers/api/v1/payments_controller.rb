class API::V1::PaymentsController < API::V1::Defaults
  before_action :set_student

  def check_student_for_customer_id
    @student = Student.find(params[:student_id])
    if @student.customer_id
      info = {
        full_name: @student.full_name,
        card: @student.card_brand + "****" + @student.last_4_digits,
        customer: @student.customer_id,
        success: true
      }
      render json: info
    else
      info = {success: false}
      render json: info
    end
  end

end