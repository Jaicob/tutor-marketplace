module CheckoutHelper

  def full_price(tutor_course_rate)
    full_price = (tutor_course_rate * 1.15)
    sprintf('%.2f', full_price)
  end

end