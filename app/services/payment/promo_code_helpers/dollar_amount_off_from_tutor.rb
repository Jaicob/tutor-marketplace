module PromoCodeHelpers
  class DollarAmountOffFromTutor

    attr_accessor :charge

    def initialize(context)
      @context = context
      @charge = context.charge
      @amount = @charge.amount
      @promotion = Promotion.find(context.promotion_id)
      @transaction_fee = ((@context.transaction_percentage.to_f / 100) + 1)
      @rates = context.rates
      @tutor = context.tutor
    end

    def return_adjusted_fees
      if is_redemption_valid?(@promotion, @tutor)
        @promotion.redemption_count += 1
        @promotion.save
      else
        puts 'Promo code is invalid'
        return 
      end
      find_discount_price_difference(@promotion, @rates)
      update_charge(@charge, @amount, @price_difference, @transaction_fee, @promotion)
      return @context
    end

    def is_redemption_valid?(promotion, tutor)
      (promotion.redemption_count < promotion.redemption_limit) && 
      (promotion.valid_from.to_date <= Date.today && Date.today <= promotion.valid_until.to_date ) && 
      (promotion.tutor_id == @tutor.id) ? 
      true : false
    end

    def find_discount_price_difference(promotion, rates)
      rates_total = rates.map(&:to_i).reduce(:+)
      discount_amount = @promotion.amount.to_i
      discount_rates_total = rates_total - discount_amount
      discount_price = discount_rates_total * @transaction_fee * 100
      regular_price = rates_total * @transaction_fee * 100
      @price_difference = regular_price - discount_price
    end

    def update_charge(charge, amount, price_difference, transaction_fee, promotion)
      new_amount = amount - price_difference
      new_tutor_fee = (new_amount.to_f / transaction_fee).to_i
      new_axon_fee = new_amount - new_tutor_fee
      charge.update(
        amount: new_amount,
        tutor_fee: new_tutor_fee,
        axon_fee: new_axon_fee,
        promotion_id: promotion.id
      )
    end

  end
end