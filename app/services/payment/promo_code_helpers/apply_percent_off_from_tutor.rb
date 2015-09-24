module PromoCodeHelpers
  class ApplyPercentOffFromTutor

    attr_accessor :context, :charge, :is_payment_required

    def initialize(context)
      @context = context
      @charge = context.charge
      @is_payment_required = context.is_payment_required
    end

    def return_adjusted_fees
      record_promotion_id_on_charge(@charge, @promotion)
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

    # def find_promo_code_value(promotion)
    #   value = promotion.amount * 100
    #   @promotion_discount = value
    # end

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