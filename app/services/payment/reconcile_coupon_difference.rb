class ReconcileCouponDifference
  include Interactor

  # Call with tutor:  Instance of Tutor
  #           amount: Difference in cents between normal and discounted price
  #           promo:  Instance of Promotion used in discount

  def call
    processor = PaymentFactory.new.build
    payment = processor.send_charge(context.charge)
    context.response = processor.reconcile_coupon_difference(context.charge)
  end
end