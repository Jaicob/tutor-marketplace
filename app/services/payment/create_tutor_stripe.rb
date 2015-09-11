class CreateTutorAccount

  def build(tutor)
    processor = PaymentFactory.new().build
    response = processor.create_managed_account(tutor)
    tutor.update_attributes(payment_acct: response[:id])
  end

end