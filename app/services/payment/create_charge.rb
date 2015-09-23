class CreateCharge
  include Interactor

  # Call with: tutor: instance_of Tutor
  #            appointments: array of Appointment
  #            customer_id: student.customer_id
  #            token: params[:token]
  #            rates: array of TutorCourse.rate in dollars
  #            transaction_percentage: School.transaction_percentage
  #            promotion_id: promotion.id (or nil)
  def call
    axon_fee_multiplier = ((context.transaction_percentage.to_f / 100) + 1)
    tutor_fee = []
    context.rates.each do |rate|
      session_amount = (rate * 100)
      tutor_fee << session_amount
    end
    tutor_fee = tutor_fee.map(&:to_i).reduce(:+)
    amount = tutor_fee * axon_fee_multiplier
    axon_fee = amount - tutor_fee
    charge = context.tutor.charges.create(token: context.token, customer_id: context.customer_id,
                                          amount: amount, axon_fee: axon_fee, tutor_fee: tutor_fee)
    context.appointments.each{|appt| appt.update_attributes(charge_id: charge.id)}
    context.charge = charge
  end

end