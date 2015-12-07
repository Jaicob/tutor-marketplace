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

  def create_student
    # required_params
      # :first_name
      # :last_name
      # :email
      # :password
      # :school_id
      # :stripe_token

    @token = params[:stripe_token]

    new_user = User.create(
      first_name: params[:first_name],
      last_name: params[:last_name],
      email: params[:email],
      password: params[:password]
    )
    
    if new_user.save
      @student = new_user.create_student(school_id: params[:school_id])
      if !@student.save
        render json: {success: false, error: @student.errors.full_messages}
      end
    else
      render json: {success: false, error: new_user.errors.full_messages}
      return
    end

    if params[:save_card] == 'true'
      Processor::Stripe.new.update_customer(@student, @token)
      if @student.reload.customer_id
        render json: { 
          success: true, 
          student_id: @student.id, 
          customer_id: @student.customer_id 
        }
        return
      else
        render json: { 
          success: false, error: 'Error with update_customer method in payments/processor/stripe.rb' 
        }
      end
    else
      render json: {
        success: true,
        student_id: @student.id,
        stripe_token: @token
      }
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

    rate = TutorCourse.where(tutor_id: @tutor.id, course_id: course_id).first.rate
    rate_array = []
    appts.count.times { rate_array << rate }

    promotion = params[:promotion_id] if !params[:promotion_id].blank?

    formatted_params = {
      tutor: @tutor,
      student: @student,
      token: params[:stripe_token],
      appointments: appts,
      rates: rate_array,
      transaction_percentage: params[:transaction_percentage],
      promotion_id: promotion,
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