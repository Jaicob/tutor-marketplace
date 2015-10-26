module PromoCodeHelpers
  class PercentOffFromAxon

    attr_accessor :charge

    def initialize(context)
      @context = context
      @charge = context.charge
      @amount = @charge.amount
      @tutor_fee = @charge.tutor_fee
      @transaction_fee = ((context.transaction_percentage.to_f / 100) + 1 )
      @promotion = Promotion.find(context.promotion_id)
      @lowest_rate = context.rates.sort.first
      @discount_multiplier = ((@promotion.amount.to_f / 100) - 1).abs
    end

    def return_adjusted_fees
      return false unless @promotion.category == 'percent_off_from_axon'
      if is_redemption_valid?(@promotion)
        @promotion.redemption_count += 1
        @promotion.save
      else
        puts 'Promo code is invalid'
        return 
      end
      find_discount_price_difference(@lowest_rate, @discount_multiplier, @transaction_fee)
      update_charge(@charge, @amount, @tutor_fee, @price_difference, @promotion)
      return @context
    end

    def is_redemption_valid?(promotion)
      (promotion.redemption_count < promotion.redemption_limit) && 
      (promotion.valid_from.to_date <= Date.today && Date.today <= promotion.valid_until.to_date ) ? 
      true : false
    end

    def find_discount_price_difference(rate, discount_multiplier, transaction_fee)
      regular_price = rate * transaction_fee * 100
      puts "REGULAR PRICE = #{regular_price}"
      discount_price = rate * transaction_fee * 100 * discount_multiplier 
      puts "DISCOUNT PRICE = #{discount_price}"
      @price_difference = regular_price - discount_price
      puts "@price_difference = #{@price_difference}"
    end

    def update_charge(charge, amount, tutor_fee, price_difference, promotion)
      new_amount = amount - price_difference.to_i
      new_axon_fee = new_amount - tutor_fee
      charge.update(
        amount: new_amount,
        axon_fee: new_axon_fee,
        promotion_id: promotion.id
      )
    end

  end
end