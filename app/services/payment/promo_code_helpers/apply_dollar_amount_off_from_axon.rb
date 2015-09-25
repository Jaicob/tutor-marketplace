module PromoCodeHelpers
  class ApplyDollarAmountOffFromAxon

    attr_accessor :context, :charge, :promotion, :promotion_id, :tutor_fee, :axon_fee, :axon_owes_tutor, :is_payment_required, :promotion_discount, :discount_price, :amount

    def initialize(context)
      @context = context
      @charge = context.charge
      @is_payment_required = context.is_payment_required
      @amount = @charge.amount
      @tutor_fee = @charge.tutor_fee
      @axon_fee = @charge.axon_fee
      @axon_owes_tutor = context.axon_owes_tutor
      @promotion = Promotion.find(context.promotion_id)
    end

    def return_adjusted_fees
      find_promo_code_value(@promotion)
      find_discounted_price(@charge, @amount, @promotion_discount)
      adjust_fees_to_cover_tutor_fee(@discount_price, @tutor_fee)
      return @context
    end

    def find_discount_price_difference(charge, amount, promotion_discount)
      
    end

    def update_charge(amount, axon_fee, promotion_id)
      new_amount
      new_axon_fee
      charge.update(amount: new_amount, axon_fee: new_axon_fee, promotion_id: promotion.id)
    end

  end
end