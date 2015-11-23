class CreateCharge
  include Interactor

  # Call with: tutor: instance_of Tutor
  #            appointments: array of Appointments
  #            customer_id: student.customer_id
  #            rates: array of TutorCourse.rate in dollars
  #            transaction_percentage: School.transaction_percentage
  #            promotion_id: promotion.id (or nil)
  def call
    axon_fee_multiplier = ((context.transaction_percentage.to_f / 100) + 1)

    tutor_rates = []

    context.rates.each do |rate|
      session_amount = (rate * 100)
      tutor_rates << session_amount
    end

    tutor_fee = tutor_rates.map(&:to_i).reduce(:+)
    amount = tutor_fee * axon_fee_multiplier
    axon_fee = amount - tutor_fee

    if context.customer_id
      charge = context.tutor.charges.create(
        customer_id: context.customer_id,
        amount: amount,
        axon_fee: axon_fee,
        tutor_fee: tutor_fee
      )
    elsif context.token
      charge = context.tutor.charges.create(
        token: context.token,
        amount: amount,
        axon_fee: axon_fee,
        tutor_fee: tutor_fee
      )
    end


    context.appointments.each{|appt| appt.update_attributes(charge_id: charge.id)}
    context.charge = charge
  end

end