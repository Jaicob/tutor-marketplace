class API::V1::PaymentsController < API::V1::Defaults
  before_action :set_student, only: [:get_customer, :create_customer, :update_default_card]

  def get_customer
    if @student.customer_id
      card = "#{@student.card_brand} **** #{@student.last_4_digits}"
      render json: {
        full_name: @student.full_name,
        card: card,
        customer: @student.customer_id,
        success: true
      }
    else
      render json: { success: false, error: 'Student does not have a customer_id' }
    end
  end

  def create_customer
    
  end

  def update_default_card
    token = params[:stripe_token]
    Processor::Stripe.new.update_customer(@student, token)
    if student.reload.customer_id
      render json: { success: true }
    else
      render json: { success: false, error: 'Error with update_customer method in payments/processor/stripe.rb' }
    end
  end

  def process_payment
    tutor = Tutor.find(params[:tutor_id])
    appts = params[:appt_ids].map { |appt| Appointment.find(appt) }
    appts.each do |appt|
      appt.student_id = params[:student_id]
      appt.save
    end

    if params[:customer_id].length > 0
      customer_id = params[:customer_id]
    else
      customer_id = nil
    end

    if params[:token].length > 0
      token = params[:token]
    else
      token = nil
    end

    if params[:promotion_id].length > 0
      promo = params[:promotion_id]
    else
      promo = nil
    end

    t = appts.first.tutor.id
    c = appts.first.course.id
    rate = TutorCourse.where(tutor_id: t, course_id: c).first.rate
    rateArray = []
    appts.count.times { rateArray << rate }

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

  private

    def set_student
      @student = Student.find(params[:student_id])
    end

end