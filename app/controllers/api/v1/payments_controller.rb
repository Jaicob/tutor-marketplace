class API::V1::PaymentsController < API::V1::Defaults
  before_action :set_student, only: [:get_customer, :update_default_card, :run_checkout_organizer]
  before_action :set_tutor, only: [:run_checkout_organizer]

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

  def run_checkout_organizer
    # required_params
      # :tutor_id
      # :student_id
      # :stripe_token
      # :appts_info [{slot_id: x, course_id: x, start_time: xxx},{slot_id: x, course_id: x, start_time: xxx}]
      # :promotion_id (optional)

    promotion = params[:promotion_id] if !params[:promotion_id].blank?

    formatted_params = {
      tutor: @tutor.id,
      student: @student.id,
      token: params[:stripe_token],
      appts_info: params[:appts_info]
      promotion_id: promotion_id,
    }

    organizer = CheckoutOrganizer.call(formatted_params)

    if organizer.NO_ERRORS?
      render json: {
        success: true,
        charge: Charge.find(organizer.charge.id)
      }
    else
      render json: {
        success: false,
        errors: errors_go_here
      }
    end
  end

  private

    def set_student
      @student = Student.find(params[:student_id])
    end

    def set_tutor
      @tutor = Tutor.find(params[:tutor_id])
    end

end