module PromoCodeHelpers
  class PercentOffFromTutor

    attr_accessor :charge

    def initialize(context)
      @context = context
      @charge = context.charge
      @amount = @charge.amount
      @transaction_fee = ((@context.transaction_percentage.to_f / 100) + 1)
      @promotion = Promotion.find(context.promotion_id)
      @lowest_rate = @context.rates.sort.first
      @discount_multiplier = ((@promotion.amount.to_f / 100) - 1).abs
    end

    def return_adjusted_fees
      if is_redemption_valid?(@promotion)
        @promotion.redemption_count += 1
        @promotion.save
      else
        puts 'Promo code is invalid'
        return 
      end
      find_discount_price_difference(@lowest_rate, @discount_multiplier, @transaction_fee)
      update_charge(@charge, @amount, @price_difference, @promotion)
      return @context
    end

    def is_redemption_valid?(promotion)
      (promotion.redemption_count < promotion.redemption_limit) && 
      (promotion.valid_from.to_date <= Date.today && Date.today <= promotion.valid_until.to_date ) ? 
      true : false
    end

    def find_discount_price_difference(rate, discount_multiplier, transaction_fee)
      regular_price = rate * transaction_fee * 100
      discount_price = rate * transaction_fee * 100 * discount_multiplier
      @price_difference = regular_price - discount_price
    end

    def update_charge(charge, amount, price_difference, promotion)
      new_amount = (amount - price_difference)
      new_tutor_fee = (new_amount.to_f / 1.15).to_i
      new_axon_fee = (new_amount - new_tutor_fee)
      charge.update(
        amount: new_amount, 
        tutor_fee: new_tutor_fee, 
        axon_fee: new_axon_fee, 
        promotion_id: promotion.id
      )
    end
    
  end
end