class ReconcileCouponDifference
  include Interactor

  # Call with tutor:  Instance of Tutor
  #           amount: Difference in cents between normal and discounted price
  #           promo:  Instance of Promotion used in discount

  def call
    if context.charge.axon_fee < 0
      processor = PaymentFactory.new.build
      payment = processor.send_charge(context.charge)
      context.response = processor.reconcile_coupon_difference(context.charge)
    end
  end
end



# def reconcile_coupon_difference(charge)
#   transfer = ::Stripe::Transfer.create(
#     amount: charge.amount,
#     currency: 'usd',
#     destination: charge.tutor.acct_id,
#     description: "Reconciliation for Coupon #{promotion.description}"
#   )
# end