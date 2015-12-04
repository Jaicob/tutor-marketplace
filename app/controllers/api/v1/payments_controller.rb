class API::V1::PaymentsController < API::V1::Defaults
  before_action :set_student, only: [:get_customer, :create_customer, :update_default_card]

  def get_customer
    if @student.customer_id
      if @student.last_4_digits
        card = "#{@student.card_brand} **** #{@student.last_4_digits}"
      end
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
    params[:first_name]
    params[:last_name]
    params[:email]
    params[:password]
    params[:stripe_token]
    params[:make_default]

    # make user and student

    # if make_default is true
      # convert stripe_token into a customer_id and save to student
    # else
      # return student with stripe_token 


    
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

    customer_id = params[:customer_id] if params[:customer_id].length > 0
    token = params[:token] if params[:token].length > 0
    promo = params[:promotion_id] if params[:promotion_id].length > 0
    course_id = appts.first.course.id

    rate = TutorCourse.where(tutor_id: tutor.id, course_id: course_id).first.rate
    rate_array = []
    appts.count.times { rate_array << rate }

    formatted_params = {
      tutor: tutor,
      appointments: appts,
      customer_id: customer_id,
      token: token,
      rates: rate_array,
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