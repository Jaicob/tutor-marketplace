module PromoCodeHelpers
  class FreeSessionFromTutor

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
        @charge.update(
          amount: 0,
          tutor_fee: 0,
          axon_fee: 0,
          promotion_id: @promotion.id
        )
      else
        @rates.sort!.slice!(0) # rates minus the lowest rate
        rates_total = @rates.reduce(:+)
        new_amount = rates_total * @transaction_fee * 100
        new_tutor_fee = rates_total * 100
        new_axon_fee = new_amount - (new_tutor_fee)
        @charge.update(
          amount: new_amount,
          tutor_fee: new_tutor_fee,
          axon_fee: new_axon_fee,
          promotion_id: @promotion.id
        )
      end
    end

  end
end