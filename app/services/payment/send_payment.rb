class SendPayment
  include Interactor

  def call
    charge = context.charge
    stripe = PaymentFactory.new(charge_id: charge.id).build
    payment = stripe.send_charge(charge)
    context.payment = payment
  end
end