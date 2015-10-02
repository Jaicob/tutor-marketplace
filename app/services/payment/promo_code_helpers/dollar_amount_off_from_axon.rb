module PromoCodeHelpers
  class DollarAmountOffFromAxon

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
      if is_redemption_valid?(@promotion, @tutor)
        @promotion.redemption_count += 1
        @promotion.save
      else
        puts 'Promo code is invalid'
        return 
      end
      update_charge(@charge, @amount, @price_difference, @tutor_fee, @promotion)
      return @context
    end

    def is_redemption_valid?(promotion, tutor)
      (promotion.redemption_count < promotion.redemption_limit) && 
      (promotion.valid_from.to_date <= Date.today && Date.today <= promotion.valid_until.to_date ) ? 
      true : false
    end

    def update_charge(charge, amount, price_difference, tutor_fee, promotion)
      new_amount = amount - (promotion.amount * 100)
      new_axon_fee = new_amount - tutor_fee
      charge.update(
        amount: new_amount,
        axon_fee: new_axon_fee,
        promotion_id: promotion.id
      )
    end

  end
end