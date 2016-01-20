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
      total_price: total_price,
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

  def redeem_promo_code
    Promotion.redeem()
  end

end