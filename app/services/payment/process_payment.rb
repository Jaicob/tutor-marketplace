class ProcessPayment
  include Interactor::Organizer

  organize CreateCharge, ApplyPromoCode, SendPayment
  # , SendEmails

end


# params = {
#   tutor: Tutor.first,
#   appointments: [Appointment.first, Appointment.second],
#   customer_id: 1,
#   token: 789867877868,
#   rates: [30, 25],
#   transaction_percentage: 17.5,
#   promotion_id: 1,
#   is_payment_required: true,
# }