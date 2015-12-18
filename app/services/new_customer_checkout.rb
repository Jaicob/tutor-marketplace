class NewCustomerCheckout

  def initialize(params, session, tutor_booked) # tutor_booked is supplied to determine school_id for new student
    # for user creation
    @first_name = params[:user][:first_name]
    @last_name = params[:user][:last_name]
    @email = params[:user][:email]
    @password = params[:user][:password]
    # for student creation
    @school_id = tutor_booked.school_id
    # boolean for Stripe customer creation
    @create_customer = (params[:create_customer] == 'true') ? true : false
    # for appointment creation
    @course_id = session[:course_id]
    @appt_info = session[:appt_info]
    @location = session[:location]
    # for charge creation
    @token = params[:stripeToken]
    @tutor = tutor_booked
    @promotion_id = session[:promotion_id]
  end

  def create_student_user
    user = User.create(
      first_name: @first_name,
      last_name: @last_name,
      email: @email,
      password: @password
    )
    
    if !user.save
      puts "ERROR! User was not created: #{user.errors.full_messages}"
      return
    end

    @student = user.create_student(
      school_id: @school_id
    )
    
    if !@student.save
      puts "ERROR! Student was not created: #{@student.errors.full_messages}"
      return
    end

    # TODO - send welcome email to student!
    if @create_customer
      Processor::Stripe.new.update_customer(@student, @token) # this method creates a customer if none exists
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
    puts "FORMATTED APPTS ARRAY!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! = #{formatted_appts_array}"
        return formatted_appts_array

  end

# {"17"=>"2015-12-19 15:00:00 UTC-!-1882", "43"=>"2015-12-21 13:30:00 UTC-!-1883"} 

# [{slot_id: x, course_id: x, start_time: xxx},{slot_id: x, course_id: x, start_time: xxx}]


  def prepare_data_for_checkout_organizer
    create_student_user
    appts_info = format_appt_info
    data = {
      tutor_id: @tutor.id,
      student_id: @student.id,
      stripe_token: @token,
      appts_info: appts_info,
      promotion_id: @promotion_id
    }
  end

end