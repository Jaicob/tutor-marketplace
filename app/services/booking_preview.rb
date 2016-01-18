class BookingPreview

  def initialize(session, tutor)
    @appt_info = session[:appt_info]
    @location = session[:location]
    @course = Course.find(session[:course_id])
    @tutor = tutor
    @rate = TutorCourse.where(tutor_id: tutor.id, course_id: @course.id).first.rate
    @promotion = Promotion.find_by(code: session[:promo_code]) if session[:promo_code]
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

    data = {
      tutor: @tutor,
      course: @course,
      rate: @rate,
      location: @location,
      appointments: @appt_hash,
      total_price: total_price,
      valid_promo: is_promo_valid?,
      promo_discount: promo_discount if is_promo_valid? == true
    }
    return data
  end

  def total_price
    number_of_appts = @appt_info.count
    total_price = number_of_appts * @rate * 1.15
    formatted_total_price = sprintf('%.2f', total_price)
    return formatted_total_price
  end

  def is_promo_valid?
    if (@promotion.redemption_count >= @promotion.redemption_limit) || (Date.today > @promotion.valid_until)
      return false
    else
      return true
    end
  end

  def promo_discount
    case @promotion.category
    when 'free_from_axon' # 0
      prefix = 'AXONFREE'
    when 'free_from_tutor' # 1
      prefix = 'TUTORFREE'
    when 'percent_off_from_axon' # 2
      prefix = 'AXONPER'
    when 'percent_off_from_tutor' # 3
      prefix = 'TUTORPER'
    when 'dollar_amount_off_from_axon' # 4
      prefix = 'AXONDLR'
    when 'dollar_amount_off_from_tutor' # 5
      prefix = 'TUTORDLR'
    when 'repeating_percent_off_from_tutor' # 6
      prefix = 'TUTORPACKPER'
    when 'repeating_dollar_amount_off_from_tutor' # 7
      prefix = 'TUTORPACKDLR'
    end
  end

  # free from Axon requires no payment and Stripe transfer from Axon to Tutor to cover fee
  # free from Tutor requires a charge for 0 to be created (only in our DB, no need to involve Stripe)
  # percent off from Axon requires lowering price of booking an entire 


end