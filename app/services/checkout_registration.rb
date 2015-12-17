class CheckoutRegistration

  def initialize(params, tutor_booked) # tutor_booked is supplied to determine school_id for new student
    @first_name = params[:first_name]
    @last_name = params[:last_name]
    @email = params[:email]
    @password = params[:password]
    @school_id = tutor_booked.school_id
    @create_customer = params[:create_customer]
  end

  def create_student_user
  end

  def create_stripe_customer
  end

end