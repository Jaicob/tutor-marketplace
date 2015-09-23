module PromoCodeServices
  class ApplyDollarAmountOffFromAxon

    def initialize(context)
      # record promotion_id on charge
      context.charge.update(promotion_id: context.promotion_id)

      # flag charge as requiring payment
      context.is_payment_required = true
      
      # find cash value of promo code (in cents!)
      promotion = Promotion.find(context.promotion_id)
      context.promotion_discount = promotion.amount * 100
      
      # decrease amount by promotion discount
      context.charge.amount = context.charge.amount - context.promotion_discount
      
      # calculate whether the amount after discount covers a booking's tutor_fee
      if context.charge.amount > context.charge.tutor_fee
        # if the amount covers the tutor_fee, then it's only necessary to reduce Axon's fee to the remaining margin
        context.charge.axon_fee = context.charge.amount - context.charge.tutor_fee
      else
        # if the amount does NOT cover the tutor_fee, then the tutor is given the entire transaction, Axon's fee is set to 0, and the additional amount owed to the tutor is recorded and transferred to the tutor via ReconcileCouponDifference
        context.axon_owes_tutor = context.charge.tutor_fee - context.charge.amount
        context.charge.axon_fee = 0
        context.charge.tutor_fee = context.charge.amount

        return_adjusted_fees(context)
      end
    end

    def return_adjusted_fees
      context = 
    end

  end
end