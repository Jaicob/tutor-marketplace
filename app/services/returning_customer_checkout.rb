class ReturningCustomerCheckout

  def initialize(params, tutor_booked) # tutor_booked is supplied to determine school_id for new student
    # @first_name = params[:first_name]
    # @last_name = params[:last_name]
    # @email = params[:email]
    # @password = params[:password]
    # @school_id = tutor_booked.school_id
    # @create_customer? = params[:create_customer]
    # @token = params[:stripeToken]
    # @tutor = tutor_booked
  end


      # if use default_card
      # elsif use new_card
        # if save new_card as default

        

  # def create_student_user
  #   user = User.create(
  #     first_name: @first_name,
  #     last_name: @last_name,
  #     email: @email,
  #     password: @password
  #   )
  #   @student = user.create_student(
  #     school_id: @school_id
  #   )
  #   # TODO - send welcome email to student!
  #   if @create_customer? == 'true'
  #     Processor::Stripe.new.update_customer(@student, @token) # this method creates a customer if none exists
  #   end
  #   return student.id
  # end

  def prepare_data_for_checkout_organizer
    # data = {
    #   tutor_id: @tutor.id,
    #   student_id: @student.id,
    #   stripe_token: @token,
    #   appts_info: data[:appts_info],
    #   promotion_id: data[:promotion_id]
    # }
  end

end