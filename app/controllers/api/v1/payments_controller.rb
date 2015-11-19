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
    appts = params[:appt_ids].map { |appt| Appointment.find(appt) }
    appts.each do |appt|
      appt.student_id = params[:student_id]
      appt.save
    end

    customer_id = if params[:customer_id].length > 0
      params[:customer_id]
    else
      nil
    end

    token = if params[:token].length > 0
      params[:token]
    else
      nil
    end

    t = appts.first.tutor.id
    c = appts.first.course.id
    rate = TutorCourse.where(tutor_id: t, course_id: c).first.rate
    rateArray = []
    appts.count.times { rateArray << rate }

    promo = if params[:promotion_id].length > 0
              params[:promotion_id]
            else
              nil
            end

    formatted_params = {
      tutor: tutor,
      appointments: appts,
      customer_id: customer_id,
      token: token,
      rates: rateArray,
      transaction_percentage: params[:transaction_percentage],
      promotion_id: promo
    }

    ProcessPayment.call(formatted_params)

    render json: Charge.last
  end
end