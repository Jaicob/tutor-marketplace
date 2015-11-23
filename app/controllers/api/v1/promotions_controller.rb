class API::V1::PromotionsController < API::V1::Defaults

def check_promo_code
  promo_code = safe_params[:promo_code]
  @tutor_id = safe_params[:tutor_id]
  @promotion = Promotion.find_by(code: promo_code)

  if @promotion
    tutor_id = safe_params
    promo_info = {
      id: @promotion.id,
      type: @promotion.category,
      value: @promotion.amount,
      is_valid: @promotion.is_valid?(@tutor_id),
      description: @promotion.description
    }
    render json: promo_info
  else
    render json: {
      is_valid: false
    }
  end

end

  private

    def safe_params
      hash = {}
      hash[:tutor_id] = params[:tutor_id] if params[:tutor_id]
      hash[:promo_code] = params[:promo_code] if params[:promo_code]
      return hash
    end

end