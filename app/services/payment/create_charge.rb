class CreateCharge
  include Interactor

  # Call with: tutor: instance_of Tutor
  #            appointments: array of Appointment
  #            customer_id: student.customer_id
  #            token: params[:token]
  #            rates: array of TutorCourse.rate in dollars
  #            transaction_percentage: School.transaction_percentage
  def call
    tutor = context.tutor
    appointments = context.appointments.zip(context.rates)
    transaction_percentage = ((context.transaction_percentage / 100) + 1)
    appointments.each do |appt|
      session_amount = (appt[1] * 100)
      amount = session_amount * transaction_percentage
      transaction_fee = amount - session_amount
      charge = tutor.charges.create(token: context.token,
                                    customer_id: context.customer_id,
                                    amount: amount,
                                    transaction_fee: transaction_fee
                                   )
      appt[0].update_attributes(charge_id: charge.id)
    end
  end

end