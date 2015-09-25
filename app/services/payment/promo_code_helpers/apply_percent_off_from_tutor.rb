module PromoCodeHelpers
  class ApplyPercentOffFromTutor

    attr_accessor :context, :charge, :is_payment_required, :rates, :discount_multiplier, :lowest_rate, :regular_session_price, :transaction_percentage, :discount_session_price, :discount_rate

    def initialize(context)
      @context = context
      @charge = context.charge
      @amount = @charge.amount
      @is_payment_required = context.is_payment_required
      @rates = context.rates
      @transaction_percentage = @context.transaction_percentage
      @promotion = Promotion.find(context.promotion_id)
      @lowest_rate = find_lowest_rate_session(@rates)
      @regular_session_price = find_regular_price_for_a_session(@lowest_rate, @transaction_percentage)
      @discount_session_price = find_discount_price_for_a_session(@lowest_rate, @transaction_percentage)
      @discount_multiplier = find_discount_multiplier_for_percent_off(@promotion)
    end

    def return_adjusted_fees
      record_promotion_id_on_charge(@charge, @promotion)
      is_payment_required?
      find_discount_multiplier_for_percent_off(@promotion)
      find_lowest_rate_session(@rates)
      find_discount_rate_for_a_session(@lowest_rate, @discount_multiplier)
      find_regular_price_for_a_session(@lowest_rate, @transaction_percentage)
      find_discount_price_for_a_session(discount_rate, @transaction_percentage)
      recalculate_fees_with_discount_price_session(@charge, @amount, @regular_session_price, @discount_session_price)
      return @context
    end

    def record_promotion_id_on_charge(charge, promotion)
      charge.update(promotion_id: promotion.id)
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

    def find_discount_rate_for_a_session(rate, discount_multiplier)
      @discount_rate = rate * discount_multiplier
    end

    def find_regular_price_for_a_session(rate, transaction_percentage)
      transaction_fee = ((transaction_percentage.to_f / 100) + 1 )
      @regular_session_price = rate * transaction_fee * 100
    end

    def find_discount_price_for_a_session(discount_rate, transaction_percentage)
      transaction_fee = ((transaction_percentage.to_f / 100) + 1 )
      @discount_session_price = discount_rate * transaction_fee * 100
    end

    def recalculate_fees_with_discount_price_session(charge, amount, regular_session_price, discount_session_price)
      new_amount = (amount - regular_session_price + discount_session_price)
      new_tutor_fee = (new_amount.to_f / 1.15).to_i
      new_axon_fee = (new_amount - new_tutor_fee)
      charge.update(amount: new_amount, tutor_fee: new_tutor_fee, axon_fee: new_axon_fee)
    end

  end
end
