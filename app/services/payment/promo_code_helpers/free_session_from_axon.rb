module PromoCodeHelpers
  class FreeSessionFromAxon

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
      if update_charge
        return @context
      else
        puts "Fees could not be calculated. Make sure all necessary parameters are passed in."
      end
    end

    def update_charge
      if @rates.count == 1
        new_amount = 0
        new_axon_fee = 0 - @charge.tutor_fee
        @charge.update(
          amount: new_amount,
          axon_fee: new_axon_fee,
          promotion_id: @promotion.id
        )
      else
        lowest_rate = @rates.sort.first
        total_price_of_lowest_rate = lowest_rate * @transaction_fee * 100
        axon_fee_on_lowest_rate_price = total_price_of_lowest_rate - (lowest_rate * 100)
        new_amount = @charge.amount - total_price_of_lowest_rate
        new_axon_fee = new_amount - @charge.tutor_fee
        @charge.update(
          amount: new_amount,
          axon_fee: new_axon_fee,
          promotion_id: @promotion.id
        )
      end
    end

  end
end