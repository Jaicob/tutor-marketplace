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

    data = {
      tutor: @tutor,
      course: @course,
      rate: @rate,
      location: @location,
      appointments: @appt_hash,
      total_price: total_price,
    }

    if !@promo_code.nil?
      @promo = redeem_promo_code
      if @promo[:success] == true
        data[:promo_data] = {
          success: @promo[:success],
          full_price: @promo[:full_price],
          discount_price: @promo[:discount_price],
          discount_value: @promo[:discount_value],
          full_tutor_fee: @promo[:full_tutor_fee],
          # full_axon_fee: @promo[:full_axon_fee,
          discount_axon_fee: @promo[:discount_axon_fee],
          promotion_id: @promo[:promotion_id],
          # description: @promo[:description],
        }
      else 
        data[:promo_data] = {
          success: false,
          error: submit_promo[:error]
        }
      end
    end

    return data
  end

  def total_price
    number_of_appts = @appt_info.count
    total_price = number_of_appts * @rate * 1.15
    formatted_total_price = sprintf('%.2f', total_price)
    return formatted_total_price
  end

  def recalculate_total_price_with_discount
    total_price - data[:promo_data][:discount_value]
  end

  def redeem_promo_code
    Promotion.redeem_promo_code(@promo_code, @rate, @appt_info.count, @tutor, @course.id)
  end

end