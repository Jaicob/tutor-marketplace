module PromoCodeHelpers
  class ApplyPercentOffFromAxon

    attr_accessor :context, :charge, :rates, :promotion, :promotion_id, :tutor_fee, :axon_fee, :axon_owes_tutor, :is_payment_required, :promotion_discount, :discount_multiplier, :discount_price, :amount, :lowest_rate, :regular_session_price, :discount_session_price, :transaction_percentage

    def initialize(context)
      @context = context
      @charge = context.charge
      @amount = @charge.amount
      @tutor_fee = @charge.tutor_fee
      @axon_fee = @charge.axon_fee
      @is_payment_required = context.is_payment_required
      @rates = context.rates
      @transaction_percentage = context.transaction_percentage
    end

    def return_adjusted_fees
      record_promotion_id_on_charge(@charge, @promotion.id)
      is_payment_required?
      find_promo_code_value(@promotion)
      calculate_discount_tutor_fee(@charge, @tutor_fee, @promotion_discount, @number_of_appointments)
      recalculate_fees_with_tutor_fee_discount(@charge, @discount_tutor_fee, @transaction_percentage)
      return @context
    end

    def record_promotion_id_on_charge(charge, promotion_id)
      charge.update(promotion_id: promotion_id)
    end

    def is_payment_required?
      @is_payment_required = true
    end

    def find_discount_multiplier_for_percent_off(promotion)
      @discount_multiplier = ((promotion.amount.to_f / 100) - 1).abs
    end

    def find_lowest_rate_session(rates)
      @lowest_rate = rates.sort.first
    end

    def find_regular_price_for_a_session(rate, transaction_percentage)
      transaction_fee = ((transaction_percentage.to_f / 100) + 1 )
      @regular_session_price = rate * transaction_fee
    end

    def find_discount_price_for_a_session(rate, transaction_percentage, discount_multiplier)
      transaction_fee = ((transaction_percentage.to_f / 100) + 1 )
      @discount_session_price = rate * transaction_fee * discount_multiplier
    end

    def recalculate_amount_with_discount_price_session(charge, amount, regular_session_price, discount_session_price)
       new_amount = amount - regular_session_price + discount_session_price
       charge.update(amount: new_amount)
    end

    # def calculate_discount_tutor_fee(charge, tutor_fee, promotion_discount, number_of_appointments)
    #   discount_tutor_fee = tutor_fee - (promotion_discount * number_of_appointments)
    #   charge.update(tutor_fee: discount_tutor_fee)
    # end

    # def recalculate_fees_with_tutor_fee_discount(charge, tutor_fee, transaction_percentage)
    #   amount = tutor_fee * ((transaction_percentage.to_f / 100) + 1)
    #   axon_fee = amount - tutor_fee
    #   charge.update(amount: amount, axon_fee: axon_fee)
    # end

  end
end


      # # record promotion_id on charge
      # context.charge.update(promotion_id: context.promotion_id)

      # # flag charge as requiring payment
      # context.is_payment_required = true
      
      # # find multiplier to calculate percent off discount (i.e. 15% = 0.85)
      # promotion = Promotion.find(context.promotion_id)
      # context.percent_off_discount_multiplier = ((promotion.amount.to_f / 100) - 1).abs # 15 = 0.15
      
      # # find lowest_rate_course (to apply discount to this one)
      # context.lowest_rate = context.rates.sort.first
      
      # # calculate normal full-price for the lowest_rate_course
      # context.axon_fee_multiplier = ((context.transaction_percentage.to_f / 100) + 1)
      # context.lowest_rate_full_price = context.lowest_rate * context.axon_fee_multiplier * 100
      
      # # multiply normal full-price by percent_off_multiplier to calculate discounted rate
      
      # context.lowest_rate_discount_price = context.lowest_rate * context.percent_off_discount_multiplier * context.axon_fee_multiplier * 100
      # # subtract the lowest_rate_course's full-price from the amount and add back the discounted rate
      # context.charge.amount = context.charge.amount - context.lowest_rate_full_price + context.lowest_rate_discount_price