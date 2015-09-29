class ApplyPromoCode
  include Interactor

  before do
    # Determines the type of a promo code (if one exists) and calls the appropriate method to evaluate that promo code category
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

    #---------------------
    # Free Session Promos
    #---------------------

    def apply_free_session_from_axon_promo
      service = PromoCodeHelpers::PercentOffFromAxon.new(context)
      context = service.return_adjusted_fees
    end

    def apply_free_session_from_tutor_promo
      service = PromoCodeHelpers::PercentOffFromTutor.new(context)
      context = service.return_adjusted_fees
    end

    #--------------------
    # Percent-Off Promos
    #--------------------

    def apply_percentage_off_from_axon_promo
      service = PromoCodeHelpers::PercentOffFromAxon.new(context)
      context = service.return_adjusted_fees
    end

    def apply_percentage_off_from_tutor_promo
      service = PromoCodeHelpers::PercentOffFromTutor.new(context)
      context = service.return_adjusted_fees
    end

    #-------------------------
    # Dollar-Amount-Off Promos
    #-------------------------

    def apply_dollar_amount_off_from_axon_promo
      service = PromoCodeHelpers::DollarAmountOffFromAxon.new(context)
      context = service.return_adjusted_fees
    end

    def apply_dollar_amount_off_from_tutor_promo
      service = PromoCodeHelpers::DollarAmountOffFromTutor.new(context)
      context = service.return_adjusted_fees
    end

    #-----------------------------------------------------------------
    # Repeating Promos (aka: Semester Packages or Grandfathered-Rates)
    #-----------------------------------------------------------------

    def apply_repeating_discount_from_tutor_promo
      service = PromoCodeHelpers::RepeatingDiscountFromTutor.new(context)
      context = service.return_adjusted_fees
    end

end