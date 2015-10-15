class ProcessPayment
  include Interactor::Organizer

  organize CreateCharge, ApplyPromoCode, ReconcileCouponDifference, SendPayment, SendEmails

end

##
# Params for easy setup/testing in console

# # free_from_axon promo
# @promotion = Promotion.create(category: 4, amount: 10, valid_from: Date.today, valid_until: Date.today + 30, redemption_limit: 200, tutor_id: 23)

# params = {
#   tutor: Tutor.find(23),
#   appointments: [Appointment.first],
#   customer_id: Student.find(22).customer_id,
#   token: 789867877868,
#   rates: [23],
#   transaction_percentage: 15.0,
#   promotion_id: @promotion.id,
#   is_payment_required: true,
# }


#   # enum category: [
#   #   :free_from_axon, 
#   #   :free_from_tutor, 
#   #   :percent_off_from_axon, 
#   #   :percent_off_from_tutor, 
#   #   :dollar_amount_off_from_axon, 
#   #   :dollar_amount_off_from_tutor, 
#   #   :repeating_percent_off_from_tutor, 
#   #   :repeating_dollar_amount_off_from_tutor]


# #  id               :integer          not null, primary key
# #  code             :string
# #  category         :integer
# #  amount           :integer
# #  valid_from       :date
# #  valid_until      :date
# #  redemption_limit :integer
# #  redemption_count :integer          default(0)
# #  description      :text
# #  tutor_id         :integer
# #  course_id        :integer
# #