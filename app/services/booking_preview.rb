class BookingPreview

  def initialize(session, tutor)
    @appt_info = session[:appt_info]
    @location = session[:location]
    @course = Course.find(session[:course_id])
    @tutor = tutor
    @tc_rate = TutorCourse.where(tutor_id: tutor.id, course_id: @course.id).first.rate * 100
    @full_rate = (@tc_rate * 1.15).round
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
      tutor_rate: @tc_rate,
      full_rate: @full_rate,
      location: @location,
      appointments: @appt_hash,
      total_price: total_price,
    }

    if !@promo_code.nil?
      promo = redeem_promo_code
      if promo[:success] == true
        data[:promo_data] = {
          success: promo[:success],
          regular_price: promo[:regular_price],
          discount_price: promo[:discount_price],
          discount_value: promo[:discount_value],
          regular_tutor_fee: promo[:regular_tutor_fee],
          discount_tutor_fee: promo[:discount_tutor_fee],
          regular_axon_fee: promo[:regular_axon_fee],
          discount_axon_fee: promo[:discount_axon_fee],
          promotion_id: promo[:promotion_id],
          description: promo[:description]
        }
        if promo[:discount_price] == 0
          data[:no_payment_due] = true
        end
      else 
        data[:promo_data] = {
          success: false,
          error: promo[:error]
        }
      end
    end

    return data
  end

  def total_price
    number_of_appts = @appt_info.count
    total_price = (number_of_appts * @full_rate).round
    return total_price
  end

  def redeem_promo_code
    Promotion.redeem_promo_code(@promo_code, @tc_rate, @appt_info.count, @tutor.id, @course.id)
  end

end