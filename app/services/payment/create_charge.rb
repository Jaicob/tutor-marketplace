class CreateCharge
  include Interactor

  # Call with: tutor: tutor_id
  #            appointments: array of appt_ids
  #            student: student_id
  #            promotion_id: promotion.id (or nil)

  def call
    context.tutor
    context.transaction_percentage = School.find()
    axon_fee_multiplier = ((context.transaction_percentage.to_f / 100) + 1)

    tutor_rates = []

    context.appointments.each do |appt|
      rate = TutorCourse.where(tutor_id: @tutor.id, course_id: course_id).first.rate

      appt.course_id
      session_amount = (rate * 100)
      tutor_rates << session_amount
    end

    rate_array = []
    appts.count.times { rate_array << rate }

    tutor_fee = tutor_rates.map(&:to_i).reduce(:+)
    amount = tutor_fee * axon_fee_multiplier
    axon_fee = amount - tutor_fee

    charge = context.tutor.charges.create(
      customer_id: context.customer_id,
      amount: amount,
      axon_fee: axon_fee,
      tutor_fee: tutor_fee
    )

    context.appointments.each{|appt| appt.update_attributes(charge_id: charge.id)}
    context.charge = charge
  end

end