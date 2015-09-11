class SendPayment
  include Interactor

  def call
    charge = context.charge
    processor = PaymentFactory.new.build
    payment = processor.send_charge(charge)
    context.payment = payment
  end
end