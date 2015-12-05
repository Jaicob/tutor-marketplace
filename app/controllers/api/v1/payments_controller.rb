class API::V1::PaymentsController < API::V1::Defaults
  before_action :set_student, only: [:get_customer, :create_customer, :update_default_card, :process_payment]
  before_action :set_tutor, only: [:process_payment]

  def get_customer
    # should I create a customer here if there is no customer?
    # or, is it even possible for a student to exist without a customer id if we always create a customer for a new student
    # if so, then should the Stripe.create_customer method go in the Student controller?
    # if that's the case, then a student always has a customer id and this just returns whether or not a student has a default card,
    # so then the action is not 'get_customer', it's more like 'check_for_card' 
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

  def create_student
    # to make user & student
      params[:first_name]
      params[:last_name]
      params[:email]
      params[:password]

    # to make customer
      params[:stripe_token]
      params[:save_card]
  end

  def update_default_card
    token = params[:stripe_token]
    Processor::Stripe.new.update_customer(@student, token)
    if @student.reload.customer_id
      render json: { success: true }
    else
      render json: { success: false, error: 'Error with update_customer method in payments/processor/stripe.rb' }
    end
  end

  def process_payment
    appts = params[:appt_ids].map { |appt| Appointment.find(appt) }
    appts.each do |appt|
      appt.update(student_id: params[:student_id])
    end

    rate = TutorCourse.where(tutor_id: @tutor.id, course_id: course_id).first.rate
    rate_array = []
    appts.count.times { rate_array << rate }

    promotion = params[:promotion_id] if !params[:promotion_id].blank?

    formatted_params = {
      tutor: @tutor,
      student: @student,
      appointments: appts,
      rates: rate_array,
      transaction_percentage: params[:transaction_percentage],
      promotion_id: promotion,
      save_card: params[:save_card]
    }

    ProcessPayment.call(formatted_params)

    render json: Charge.last
  end

  private

    def set_student
      @student = Student.find(params[:student_id])
    end

    def set_tutor
      @tutor = Tutor.find(params[:tutor_id])
    end

end