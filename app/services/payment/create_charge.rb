class CreateCharge
  include Interactor
  
  ##
  # Call with: tutor_id: tutor_id
  #       appointments: array of appt_ids
  #       student_id: student_id
  #       promotion_id: promotion.id (or nil)

  ##
  # Charge attributes
  #       id               :integer          not null, primary key
  #       amount           :float
  #       axon_fee         :float
  #       tutor_fee        :float
  #       tutor_id         :integer
  #       token            :string
  #       created_at       :datetime         not null
  #       updated_at       :datetime         not null
  #       promotion_id     :integer
  #       student_id       :integer
  #       stripe_charge_id :string

  def call
    begin 
      @tutor = Tutor.find(context.tutor_id)
      @student = Student.find(context.student_id)
      @course = Course.find(context.appointments.first.course_id)
      @timezone = @course.school.timezone
      @appt_times = context.appointments.map{|appt| appt.start_time.in_time_zone(@timezone).strftime("%A, %B %e at %l:%M %p")}
      @cart = Cart.find(context.cart_id)

      context.transaction_percentage = School.find(@tutor.school_id).transaction_percentage
      axon_fee_multiplier = ((context.transaction_percentage.to_f / 100) + 1)

      tutor_rates = [] # array of rates in cents
      context.rates = [] # array of rates in dollar amounts

      context.appointments.each do |appt|
        rate = TutorCourse.where(tutor_id: @tutor.id, course_id: appt.course_id).first.rate
        context.rates << rate
        tutor_rate_in_cents = (rate * 100)
        tutor_rates << tutor_rate_in_cents 
      end

      tutor_fee = tutor_rates.map(&:to_i).reduce(:+)
      amount = (tutor_fee * axon_fee_multiplier).round
      axon_fee = amount - tutor_fee

      charge = @tutor.charges.create(
        student_id: @student.id,
        amount: amount,
        axon_fee: axon_fee,
        tutor_fee: tutor_fee,
        token: context.stripe_token
      )

      # attach charge id to 
      @cart.update(charge_id: charge.id)
      @cart.save

      # TODO-JT - error message for charge creation failure?

      context.charge_description = "Student: #{@student.full_name}, Tutor: #{@tutor.full_name}, Course: #{@course.formatted_name}, School: #{@course.school.name}, Appts: #{context.appointments.count}, Time(s): #{@appt_times}"

      context.appointments.each{|appt| appt.update_attributes(charge_id: charge.id)}
      context.charge = charge

    rescue => error
      context.fail!(
        error: error,
        failed_interactor: self.class
      )
    end
  end

  def rollback
    context.charge.destroy
    cart = Cart.find(context.cart_id)
    cart.update(charge_id: nil)
    cart.save
  end

end