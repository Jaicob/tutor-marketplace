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
    transaction_percentage = ((context.transaction_percentage / 100) + 1)
    total_amount = []
    context.rates.each do |rate|
      session_amount = (rate * 100)
      total_amount << session_amount
    end
    total_amount = total_amount.map(&:to_i).reduce(:+)
    amount = total_amount * transaction_percentage
    transaction_fee = amount - total_amount
    charge = context.tutor.charges.create(token: context.token, customer_id: context.customer_id,
                                          amount: amount, transaction_fee: transaction_fee)
    context.appointments.each{|appt| appt.update_attributes(charge_id: charge.id)}
    context.charge = charge
  end

end

params = {
  tutor: Tutor.first,
  appointments: [Appointment.first, Appointment.second],
  customer_id: 1,
  token: 789867877868,
  rates: [30, 25],
  transaction_percentage: 17.5,
  promotion_id: 1,
  is_payment_required: true,
}