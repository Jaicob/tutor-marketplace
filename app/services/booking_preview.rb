class BookingPreview

  def initialize(cart, tutor, current_user, receipt_only=nil)
    @appt_times = cart.info[:appt_times]
    @location = cart.info[:location]
    @course = Course.find(cart.info[:course_id])
    @tutor = tutor
    @tc_rate = TutorCourse.where(tutor_id: tutor.id, course_id: @course.id).first.rate * 100
    @full_rate = (@tc_rate * 1.15).round
    @promo_code = cart.info[:promo_code]
    @student_id = current_user.student.id if !current_user.nil? && current_user.role != 'tutor'
    @receipt_only = receipt_only # this is only set in the Student Dashboard controller home action when a receipt is diplayed, flag is necessary to bypass validations (because after the checkout has been completed a StudentsPromotions record exists and if promo is a no_repeat type then it won't pass the validation and display the formatted pricescorrectly)
  end

  # private method
  def extract_appt_times_and_slot
    @appt_hash = {}
    count = 1
    @appt_times.each do |info|
      array = info.second.split('-!-')
      @appt_hash[count] = {
        start_time: array.first,
        slot_id: array.second,
      }
      count += 1
    end
    return @appt_hash
  end

  # public method
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

  # private method
  def total_price
    number_of_appts = @appt_times.count
    total_price = (number_of_appts * @full_rate).round
    return total_price
  end

  # private method
  def redeem_promo_code
    Promotion.redeem_promo_code(@promo_code, @tc_rate, @appt_times.count, @tutor.id, @course.id, @student_id, @receipt_only)
  end

end
