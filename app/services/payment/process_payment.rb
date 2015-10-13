class ProcessPayment
  include Interactor::Organizer

  organize CreateCharge, ApplyPromoCode, ReconcileCouponDifference, SendPayment
  # TODO: add SendEmails interactor

end

##
# Params for easy setup/testing in console

params = {
  tutor: Tutor.first,
  appointments: [Appointment.first],
  customer_id: Student.find(22).customer_id,
  token: 789867877868,
  rates: [23],
  transaction_percentage: 15.0,
  promotion_id: 1,
  is_payment_required: true,
}