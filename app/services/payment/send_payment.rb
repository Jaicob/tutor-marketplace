class SendPayment
  include Interactor

  def call
    if context.is_payment_required == true
      charge = context.charge
      processor = PaymentFactory.new.build
      payment = processor.send_charge(charge)
      context.payment = payment
    else
      puts "No payment required"
      return
    end
  end
end