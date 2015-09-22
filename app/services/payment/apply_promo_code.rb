class ApplyPromoCode
  include Interactor

  def call
    promo_category = Promotion.find(context.promotion_id).category
    case promo_category
      when 'free_from_axon'
        apply_free_axon_session_promo
      when 'free_from_tutor'
        apply_free_tutor_session_promo
      when 'dollar_amount_off'
        apply_dollar_amount_off_promo
      when 'percent_off'
        apply_percentage_off_promo
      when 'semester_package'
        apply_semester_package_promo
    end
  end
  
  private

    def apply_free_axon_session_promo
      context.is_payment_required = false
    end

    def apply_free_tutor_session_promo
      context.is_payment_required = false
    end

    def apply_dollar_amount_off_promo
      context.is_payment_required = true
    end

    def apply_percentage_off_promo
      context.is_payment_required = true
    end

    def apply_semester_package_promo
      context.is_payment_required = false
    end

end