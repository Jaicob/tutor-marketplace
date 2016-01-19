class BookingPreview

  def initialize(session, tutor)
    @appt_info = session[:appt_info]
    @location = session[:location]
    @course = Course.find(session[:course_id])
    @tutor = tutor
    @rate = TutorCourse.where(tutor_id: tutor.id, course_id: @course.id).first.rate
    @promo_code = session[:promo_code]
  end

  def extract_appt_times_and_slot
    @appt_hash = {}
    count = 1
    @appt_info.each do |info|
      array = info.second.split('-!-')
      @appt_hash[count] = {
        start_time: array.first,
        slot_id: array.second
      }
      count += 1
    end
    return @appt_hash
  end

  def format_info
    extract_appt_times_and_slot
    is_promo_code_valid if !@promo_code.nil?

    data = {
      tutor: @tutor,
      course: @course,
      rate: @rate,
      location: @location,
      appointments: @appt_hash,
      total_price: total_price
    }

    if @promotion
      format_discount_info
      data[:valid_promotion] = true
      data[:promo_description] = @promotion.description
      data[:promo_discount_value] = @discount_value
      data[:total_price] = total_price.to_i - @discount_value.to_i
    end

    return data
  end

  def total_price
    number_of_appts = @appt_info.count
    total_price = number_of_appts * @rate * 1.15
    formatted_total_price = sprintf('%.2f', total_price)
    return formatted_total_price
  end

  def is_promo_code_valid
    @promotion = Promotion.find_by(code: @promo_code)
    # step 1: check if promo code matches up with a promotion (i.e. can the above line find a promotion)
    if @promotion.nil?
      response = {
        success: false,
        error: "Promo code was not found. Please check that you entered the code correctly. If you continue to have problems, please contact support at info@axontutors.com"
      }
    else
      # (step 2: check if promotion has expired) && (step 3: check if promo still has reached redemption limit)
      if (Date.today > @promotion.valid_until) || (@promotion.redemption_count >= @promotion.redemption_limit)
        response = {
          success: false,
          error: "Promo code has expired."
        }
      else
        response = {
          success: true
        }
      end
    end
    return response
  end

  def format_discount_info
    # figure out amount of discount and save to @discount_value
    promo_category = @promotion.category.to_sym

    case promo_category
      
      when :free_from_axon
        @discount_value = total_price
      
      # when :free_from_tutor
      #   @method = apply_free_from_tutor_promo
      
      when :percent_off_from_axon
        @discount_value = total_price.to_i * @promotion.amount
      
      # when :percent_off_from_tutor
      #   @method = apply_percentage_off_from_tutor_promo
      
      # when :dollar_amount_off_from_axon
      #   @method = apply_dollar_amount_off_from_axon_promo
      
      # when :dollar_amount_off_from_tutor
      #   @method = apply_dollar_amount_off_from_tutor_promo

      # when :repeating_percent_off_from_tutor
      #   @method = apply_repeating_percent_off_from_tutor_promo

      # when :repeating_dollar_amount_off_from_tutor
      #   @method = apply_repeating_dollar_amount_off_from_tutor_promo

    end


  end

end

# info = {"11"=>"2015-12-16 12:00:00 UTC-!-164", "13"=>"2015-12-16 13:00:00 UTC-!-164"}