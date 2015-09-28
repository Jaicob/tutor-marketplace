module PromoCodeHelpers
  class ApplyDollarAmountOffFromAxon

    attr_accessor :charge

    def initialize(context)
      @context = context
      @charge = context.charge
      @amount = @charge.amount
      @tutor_fee = @charge.tutor_fee
      @promotion = Promotion.find(context.promotion_id)
      @transaction_fee = ((@context.transaction_percentage.to_f / 100) + 1)
      @rates = context.rates
    end

    def return_adjusted_fees
      if update_charge(@charge, @amount, @price_difference, @tutor_fee, @promotion)
        return @context
      else
        errors.add(:discount_price, "could not be caluclated. Make sure all necessary parameters are passed in.")
      end
    end

    def update_charge(charge, amount, price_difference, tutor_fee, promotion)
      new_amount = amount - (@promotion.amount * 100)
      new_axon_fee = new_amount - tutor_fee
      charge.update(
        amount: new_amount,
        axon_fee: new_axon_fee,
        promotion_id: promotion.id
      )
    end

  end
end