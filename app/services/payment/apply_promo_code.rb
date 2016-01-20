class ApplyPromoCode
  include Interactor

  before do
    # Determines the type of a promo code (if one exists) and calls the appropriate method to evaluate that promo code category
    if context.promotion_id != nil
      promo_category = Promotion.find(context.promotion_id).category.to_sym
    else
      @method = nil
    end
  end

  def call
    begin
      @method
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