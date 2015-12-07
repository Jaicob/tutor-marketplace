class API::V1::PaymentsController < API::V1::Defaults
  before_action :set_student, only: [:get_customer, :create_customer, :update_default_card, :process_payment]
  before_action :set_tutor, only: [:process_payment]

  def get_customer
    # required_params
      # :student_id

    if @student.customer_id
      card = "#{@student.card_brand} **** #{@student.last_4_digits}" if @student.last_4_digits
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

  def update_default_card
    # required_params
      # :student_id
      # :stripe_token

    token = params[:stripe_token]
    Processor::Stripe.new.update_customer(@student, token)
    if @student.reload.customer_id
      render json: { success: true }
    else
      render json: { success: false, error: 'Error with update_customer method in payments/processor/stripe.rb' }
    end
  end

  def process_payment
    # required_params
      # :student_id
      # :stripe_token
      # :appt_ids
  
    appts = params[:appt_ids].map { |appt| Appointment.find(appt) }
    appts.each do |appt|
      appt.update(student_id: params[:student_id])
    end

    promotion = params[:promotion_id] if !params[:promotion_id].blank?

    formatted_params = {
      tutor: @tutor.id,
      student: @student.id,
      token: params[:stripe_token],
      appointments: appt_ids,
      promotion_id: promotion_id,
    }

    context = ProcessPayment.call(formatted_params)

    render json: {
      success: true,
      charge: Charge.find(context.charge.id)
    }
  end

  private

    def set_student
      @student = Student.find(params[:student_id])
    end

    def set_tutor
      @tutor = Tutor.find(params[:tutor_id])
    end

end