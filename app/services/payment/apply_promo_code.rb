class ApplyPromoCode
  include Interactor

  def call
    begin
    if context.promo_code != nil

      promo_code = context.promo_code
      tc_rate_in_cents = context.rates.first * 100
      appt_count = context.appointments.count
      tutor_id = context.tutor_id
      course_id = context.appointments.first.course_id

      promo = Promotion.redeem_promo_code(promo_code, tc_rate_in_cents, appt_count, tutor_id, course_id)
      if promo[:success] == true
        charge = context.charge
        charge.update(
          amount: promo[:discount_price],
          axon_fee: promo[:discount_axon_fee],
          tutor_fee: promo[:discount_tutor_fee],
          promotion_id: promo[:promotion_id]
        )
      else
        raise 'PROMOTION ERROR'
      end
    end

    rescue => error
      context.fail!(
        error: error,
        failed_interactor: self.class
      )
    end
  end

  def rollback
    if context.promotion_id
      promo = Promotion.find(context.promotion_id)
      promo.redemption_count -= 1
      promo.save
    end
  end

end