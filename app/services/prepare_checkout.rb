class PrepareCheckout

  def initialize(params, session, tutor_booked, student) # tutor_booked is supplied to determine school_id for new student
    # for user creation
    if params[:user]
      @first_name = params[:user][:first_name]
      @last_name = params[:user][:last_name]
      @email = params[:user][:email]
      @password = params[:user][:password]
    else 
      @student = student
    end
    # for student creation
    @school_id = tutor_booked.school_id
    # boolean for Stripe customer creation
    @save_card = (params[:save_card] == 'true') ? true : false
    # for appointment creation
    @course_id = session[:course_id]
    @appt_info = session[:appt_info]
    @location = session[:location]
    # for charge creation
    @token = params[:stripeToken]
    @tutor = tutor_booked
    @promotion_id = session[:promotion_id]
  end

  def prepare_data_for_checkout_organizer
    begin 
      create_student_user
      save_card_on_stripe_customer
      appts_info = format_appt_info
      data = {
        success: true,
        tutor_id: @tutor.id,
        student_id: @student.id,
        stripe_token: @token,
        appts_info: appts_info,
        promotion_id: @promotion_id
      }
      # if !@first_name.nil?
      #   data[:new_user] = true
      # end
    rescue Exception => e
      data = {
        success: false,
        error: e
      }
      return data
    end
  end

  def create_student_user
    if !@first_name.nil?
      user = User.create!(
        first_name: @first_name,
        last_name: @last_name,
        email: @email,
        password: @password
      )
      @student = user.create_student!(
        school_id: @school_id
      )
      # TODO - send welcome email to student!
    end
  end

  def save_card_on_stripe_customer
    if @save_card
      Processor::Stripe.new.update_customer(@student, @token) # this method both creates a customer if none exists and updates the default card on an existing customer
    end
  end

  def format_appt_info
    formatted_appts_array = []
    @appt_info.each do |checkbox_id, appt_data|
      x = appt_data.split('----')
      appt_hash = {
        start_time: x.first,
        slot_id: x.second,
        course_id: @course_id
      }
      formatted_appts_array << appt_hash
    end
    return formatted_appts_array
  end

end