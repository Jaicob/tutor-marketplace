class ProcessPayment
  include Interactor::Organizer

  organize CreateCharge, ApplyPromoCode, ReconcileCouponDifference, SendPayment, SendEmails

end

##
# Params for easy setup/testing in console

# @promotion = Promotion.create(category: 5, amount: 10, valid_from: Date.today, valid_until: Date.today + 30, redemption_limit: 200, tutor_id: 23)

# params = {
#   tutor: Tutor.find(23),
#   appointments: [Appointment.first],
#   customer_id: Student.find(22).customer_id,
#   rates: [23],
#   transaction_percentage: 15.0,
#   promotion_id: @promotion.id,
#   is_payment_required: true
# }

# When called in isolation for preview of charges during checkout, before final payment, it's OK to omit customer_id