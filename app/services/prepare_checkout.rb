class PrepareCheckout

  # {"default_or_new_card"=>"new-card", "save_card"=>"true", "stripeToken"=>"tok_17Sqid4Iy02hWvBEW7nqQAZr", "id"=>"jjobe"}
  # {"default_or_new_card"=>"default-card", "id"=>"jjobe"}

  def initialize(params, session, tutor_booked, student=nil) # tutor_booked is supplied to determine school_id for new student
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
    @default_or_new_card = params[:default_or_new_card]
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
        location: @location,
        stripe_token: @token,
        appts_info: appts_info,
        promotion_id: @promotion_id,
        new_user?: @new_user,
        new_user_id: @new_user_id,
        one_time_card: @one_time_card
      }
      return data

    # error handling for Stripe errors
    rescue ::Stripe::StripeError => e
      data = {
        success: false,
        error: e.message,
        new_user?: @new_user,
        new_user_id: @new_user_id
      }
      return data

    # error handling for ActiveRecord errors
    rescue Exception => e
      data = {
        success: false,
        error: e.record.errors.full_messages.first,
        new_user?: @new_user,
        new_user_id: @new_user_id
      }
      return data
    end
  end

  def create_student_user
    if @student.nil?

      user = User.create!(
        first_name: @first_name,
        last_name: @last_name,
        email: @email,
        password: @password
      )

      @student = user.create_student!(
        school_id: @school_id
      )

      @new_user = true
      @new_user_id = user.id

      # TODO-JT - send welcome email to student

    end
  end

  def save_card_on_stripe_customer
    if @save_card
      # this method both creates a customer if none exists and updates the default card on an existing customer
      Processor::Stripe.new.update_customer(@student, @token)
    else
      # this serves as a flag to not use the default_card (and use a card token instead) when a customer chooses to use a different card and NOT save it
      if @default_or_new_card != 'default-card'
        @one_time_card = true
      end
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