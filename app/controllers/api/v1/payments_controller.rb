class API::V1::PaymentsController < API::V1::Defaults
  before_action :set_student
  def check_student_for_customer_id
    @student = Student.find(params[:student_id])
    if @student
      card = if @student.card_brand && @student.last_4_digits
        "#{@student.card_brand} **** #{@student.last_4_digits}"
      else
        nil
      end
      render json: {
        full_name: @student.full_name,
        card: card,
        customer: @student.customer_id,
        success: true
      }
    else
      render json: {
        success: false
      }
    end
  end

  def process_payment
    tutor = Tutor.find(params[:tutor_id])
    appt_array = []
    appt_ids.each {|appt| @appt_array << Appointment.find(appt)}
    customer_id = Student.find(params[:student_id]).customer_id

    formatted_params = {
      tutor: tutor,
      appointments: [appt_array],
      customer_id: customer_id,
      rates: params[:rates],
      transaction_percentage: params[:transaction_percentage],
      promotion_id: params[:promotion_id]
    }

    ProcessPayment.call(formatted_params)
  end
end