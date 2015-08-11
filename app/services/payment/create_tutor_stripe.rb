class CreateTutorAccount

  def build(tutor)
    stripe = Payment::Stripe.new
    response = stripe.create_managed_account(tutor)
    tutor.update_attributes(payment_acct: response[:id])
  end

end