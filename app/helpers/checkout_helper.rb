module CheckoutHelper

  def display_price(any_amount_in_cents)
    amount_in_dollars = any_amount_in_cents / 100.to_f
    sprintf('%.2f', amount_in_dollars)
  end

  def full_price(tutor_course_rate)
    tutor_course_rate * 100 * 1.15
  end

end