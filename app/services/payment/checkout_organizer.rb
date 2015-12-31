class CheckoutOrganizer
  include Interactor::Organizer

  # required_params
    # :tutor_id
    # :student_id
    # :stripe_token
    # :appts_info [{slot_id: x, course_id: x, start_time: xxx},{slot_id: x, course_id: x, start_time: xxx}]
    # :promotion_id (optional)

  organize CreateAppointments, CreateCharge, ApplyPromoCode, ReconcileCouponDifference, SendPayment, SendEmails

end





# ##
# # MOCK DATA FOR EASY TESTING

# ##
# # Create a Promotion
#   Promotion.create(category: 0, amount: nil, valid_from: Date.today, valid_until: Date.today + 10, redemption_limit: 1)

# ##
# # Create a managed account for a Tutor
#   token = Stripe::Token.create(
#       :bank_account => {
#       :country => "CA",
#       :currency => "usd",
#       :name => "Jane Austen",
#       :account_holder_type => "individual",
#       :routing_number => "110000000",
#       :account_number => "000123456789",
#     },
#   )

#   Processor::Stripe.new.update_managed_account(Tutor.first, token)

# ##
# # Create a card token for mock Student payment
  # token_object = Stripe::Token.create(
  #   :card => {
  #     :number => "4242424242424242",
  #     :exp_month => 12,
  #     :exp_year => 2016,
  #     :cvc => "314"
  #   }
  # )

# ##
# # Run CheckoutOrganizer
  # CheckoutOrganizer.call(
  #   tutor_id: 1,
  #   student_id: 1,
  #   stripe_token: token_object.id,
  #   appts_info: [
  #     {slot_id: 1, course_id: 1, start_time: "2015-12-08 12:00:00" },
  #     {slot_id: 2, course_id: 1, start_time: "2015-12-15 12:00:00" },
  #   ],
  #   promotion_id: nil
  # )