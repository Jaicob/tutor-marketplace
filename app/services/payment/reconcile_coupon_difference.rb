class ReconcileCouponDifference
  include Interactor

  # Call with tutor:  Instance of Tutor
  #           amount: Difference in cents between normal and discounted price
  #           promo:  Instance of Promotion used in discount

  def call
    if context.charge.axon_fee < 0
      # completely free session - Axon pays entire fee
      #   - or - 
      # AXON discounted session - Axon needs to pay part of tutor fee
      processor = PaymentFactory.new.build
      tutor = context.charge.tutor
      transfer_amount = context.charge.axon_fee.abs
      promotion = Promotion.find(context.promotion_id)
      processor.reconcile_coupon_difference(tutor, transfer_amount, promotion)
    else 
      # session is either full price or discounted by tutor - Axon does not owe tutor any extra $
      return
    end
  end
end