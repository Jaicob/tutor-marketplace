class ProcessPayment
  include Interactor::Organizer

  organize SetCustomer, CreateCharge, ApplyPromoCode, ReconcileCouponDifference, SendPayment, SendEmails, DestroyCard

end

##
# Params for easy setup/testing in console

# @promotion = Promotion.create(category: 5, amount: 10, valid_from: Date.today, valid_until: Date.today + 30, redemption_limit: 200, tutor_id: 23)

# params = {
#   tutor: Tutor object,
#   appointments: [array of Appointment objects],
#   student: Student object,
#   rates: [array of integers (representing dollar amounts)],
#   transaction_percentage: 15.0,
#   promotion_id: promotion_id,
#   is_payment_required: true
# }

# When called in isolation for preview of charges during checkout, before final payment, it's OK to omit customer_id