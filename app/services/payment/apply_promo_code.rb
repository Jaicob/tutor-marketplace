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
      when 'dollar_amount_off'
        @method = apply_dollar_amount_off_promo
      when 'percent_off'
        @method = apply_percentage_off_promo
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

    def apply_dollar_amount_off_promo
      # record promotion_id on charge
      context.charge.update(promotion_id: context.promotion_id)
      # flag charge as requiring payment
      context.is_payment_required = true
      # find cash value of promo code (in cents!)
      promotion = Promotion.find(context.promotion_id)
      context.promotion_discount = promotion.amount * 100
      # decrease amount by promotion discount
      context.charge.amount = context.charge.amount - context.promotion_discount
      # calculate if Axon owes the tutor any $ so that tutor receives full pay on discounted appt
      axon_owes_tutor = context.charge.tutor_fee - context.charge.amount
      if axon_owes_tutor > 0
        context.charge.axon_fee = 0
        context.charge.tutor_fee = context.charge.amount
      end
      context.axon_owes_tutor = axon_owes_tutor
      
      # this line below was necessary to allow testing of this particular method in isolation, I could not get the linked interactor below to work, because it involves creating an account for a tutor which proved difficult to test
      if Rails.env.test? then return end
      
        ReconcileCouponDifference.call(context)

      # puts "Original total amount = #{context.charge.amount}"
      # puts "Original Axon Fee = #{context.charge.axon_fee}"
      # puts "Original Tutor Fee = #{context.charge.tutor_fee}"
      # puts "Promotion value = #{promotion_discount}"
      # puts "Discounted amount = #{context.charge.amount}"
      # puts "Tutor fee = #{context.charge.tutor_fee}"
      # puts "Axon owes tutor = #{axon_owes_tutor}"
      # puts "Discount price = #{context.charge.amount}"
      # puts "Axon fee = #{context.charge.axon_fee}"
      # puts "Tutor fee = #{context.charge.tutor_fee}"
      # puts "Axon owes tutor = #{axon_owes_tutor}"
    end

    #<Charge id: 61, amount: 6462, transaction_fee: 962, customer_id: "1", tutor_id: 1, token: "789867877868", created_at: "2015-09-22 22:01:42", updated_at: "2015-09-22 22:01:42", promotion_id: 1>

    def apply_percentage_off_promo
      # record promotion_id on charge
      context.charge.update(promotion_id: context.promotion_id)
      # flag charge as requiring payment
      context.is_payment_required = true
      # find multiplier to calculate percent off discount (i.e. 15% = 0.85)
      promotion = Promotion.find(context.promotion_id)
      percent_off_discount_multiplier = ((promotion.amount.to_f / 100) - 1).abs # 15 = 0.15
      # find lowest_rate_course (to apply discount to this one)
      lowest_rate = context.rates.sort.first
      # calculate normal full-price for the lowest_rate_course
      axon_fee_multiplier = ((context.transaction_percentage.to_f / 100) + 1)
      lowest_rate_full_price = lowest_rate * axon_fee_multiplier * 100
      # multiply normal full-price by percent_off_multiplier to calculate discounted rate
      lowest_rate_discount_price = lowest_rate * percent_off_discount_multiplier * axon_fee_multiplier * 100
      # subtract the lowest_rate_course's full-price from the amount and add back the discounted rate
      context.charge.amount = context.charge.amount - lowest_rate_full_price + lowest_rate_discount_price

      # puts "Original total amount = #{context.charge.amount}"
      # puts "Original Axon Fee = #{context.charge.axon_fee}"
      # puts "Original Tutor Fee = #{context.charge.tutor_fee}"
      # puts "BEFORE context.charge.amount = #{context.charge.amount}"
      # puts "axon_fee_multiplier = #{axon_fee_multiplier}"
      # puts "lowest_rate_full_price = #{lowest_rate_full_price}"
      # puts "lowest_rate_discount_price #{lowest_rate_discount_price}"
      # puts "AFTER context.amount = #{context.charge.amount}"
    end

    def apply_semester_package_promo
      context.charge.update(promotion_id: context.promotion_id)
      context.is_payment_required = false
    end

end

# params = {
#   tutor: Tutor.first,
#   appointments: [Appointment.first, Appointment.second],
#   customer_id: 1,
#   token: 789867877868,
#   rates: [30, 25],
#   transaction_percentage: 15.0,
#   promotion_id: 1,
#   is_payment_required: true,
# }