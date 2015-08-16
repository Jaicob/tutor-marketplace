class SendPayment
  include Interactor

  def call
    charge = context.charge
    processor = PaymentFactory.new(charge_id: charge.id).build
    payment = processor.send_charge(charge)
    context.payment = payment
  end
end