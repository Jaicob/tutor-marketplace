module CheckoutHelper

  def display_price(any_amount_in_cents)
    amount_in_dollars = any_amount_in_cents / 100.to_f
    sprintf('%.2f', amount_in_dollars)
  end

end