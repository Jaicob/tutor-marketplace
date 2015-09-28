module PromoCodeHelpers
  class ApplyDollarAmountOffFromTutor

    attr_accessor :charge

    def initialize(context)
      @context = context
      @charge = context.charge
      @amount = @charge.amount
      @promotion = Promotion.find(context.promotion_id)
      @transaction_fee = ((@context.transaction_percentage.to_f / 100) + 1)
      @rates = context.rates
    end

    def return_adjusted_fees
      if find_discount_price_difference(@promotion, @rates)
        update_charge(@charge, @amount, @price_difference, @transaction_fee, @promotion)
      else
        errors.add(:discount_price, "could not be caluclated. Make sure all necessary parameters are passed in.")
      end
      return @context
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