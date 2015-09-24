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
      record_promotion_id_on_charge(@charge, @promotion)
      is_payment_required?
      find_promo_code_value(@promotion)
      find_discounted_price(@charge, @amount, @promotion_discount)
      adjust_fees_to_cover_tutor_fee(@discount_price, @tutor_fee)
      return @context
    end

    def record_promotion_id_on_charge(charge, promotion_id)
      charge.update(promotion_id: promotion_id)
    end

    def is_payment_required?
      @is_payment_required = true
    end

    def find_promo_code_value(promotion)
      value = promotion.amount * 100
      @promotion_discount = value
    end

    def find_discount_price(charge, amount, promotion_discount)
      @discount_price = amount - promotion_discount
      charge.update(amount: @discount_price)
    end

    def adjust_fees_to_cover_tutor_fee(discount_price, tutor_fee)
      if discount_price > tutor_fee
        @axon_fee = discount_price - tutor_fee
      else
        @axon_owes_tutor = tutor_fee - discount_price
        @axon_fee = 0
        @tutor_fee = discount_price
      end
    end

  end
end