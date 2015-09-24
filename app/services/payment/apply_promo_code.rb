class ApplyPromoCode
  include Interactor

  before do
    # this determines the type of a promo code (if one exists) and calls the appropriate method to evaluate that promo code category
    if context.promotion_id != nil
      @promotion = Promotion.find(context.promotion_id)
      promo_category = @promotion.category
      case promo_category
      when 'free_from_axon'
        @method = apply_free_axon_session_promo
      when 'free_from_tutor'
        @method = apply_free_tutor_session_promo
      when 'dollar_amount_off_from_axon'
        @method = apply_dollar_amount_off_from_axon_promo
      when 'percent_off_from_tutor'
        @method = apply_percentage_off_from_axon_promo
      when 'semester_package'
        @method = apply_semester_package_promo
      end
    else
      @method = nil
    end
  end

  def call
    @method
  end
  
  private

    def apply_free_axon_session_promo
      context.charge.update(promotion_id: context.promotion_id)
      context.is_payment_required = false
    end

    def apply_free_tutor_session_promo
      context.charge.update(promotion_id: context.promotion_id)
      context.is_payment_required = false
    end

    def apply_dollar_amount_off_from_axon_promo
      service = PromoCodeServices::ApplyDollarAmountOffFromAxon.new(context)
      context = service.return_adjusted_fees
      # this if? was necessary to allow testing of this particular method in isolation
      if !Rails.env.production? then return end
      ReconcileCouponDifference.call(context)
    end

    def apply_dollar_amount_off_from_tutor_promo
      service = PromoCodeServices::ApplyDollarAmountOffFromTutor.new(context)
      context = service.return_adjusted_fees
      # this if? was necessary to allow testing of this particular method in isolation
      if !Rails.env.production? then return end
      ReconcileCouponDifference.call(context)
    end

    def apply_percentage_off_from_tutor_promo
      # record promotion_id on charge
      context.charge.update(promotion_id: context.promotion_id)
      # flag charge as requiring payment
      context.is_payment_required = true
      # find multiplier to calculate percent off discount (i.e. 15% = 0.85)
      promotion = Promotion.find(context.promotion_id)
      context.percent_off_discount_multiplier = ((promotion.amount.to_f / 100) - 1).abs # 15 = 0.15
      # find lowest_rate_course (to apply discount to this one)
      context.lowest_rate = context.rates.sort.first
      # calculate normal full-price for the lowest_rate_course
      context.axon_fee_multiplier = ((context.transaction_percentage.to_f / 100) + 1)
      context.lowest_rate_full_price = context.lowest_rate * context.axon_fee_multiplier * 100
      # multiply normal full-price by percent_off_multiplier to calculate discounted rate
      context.lowest_rate_discount_price = context.lowest_rate * context.percent_off_discount_multiplier * context.axon_fee_multiplier * 100
      # subtract the lowest_rate_course's full-price from the amount and add back the discounted rate
      context.charge.amount = context.charge.amount - context.lowest_rate_full_price + context.lowest_rate_discount_price
    end

    def apply_semester_package_promo
      context.charge.update(promotion_id: context.promotion_id)
      context.is_payment_required = false
    end

end

params = {
  tutor: Tutor.first,
  appointments: [Appointment.first, Appointment.second],
  customer_id: 1,
  token: 789867877868,
  rates: [30, 25],
  transaction_percentage: 15.0,
  promotion_id: 1,
  is_payment_required: true,
}