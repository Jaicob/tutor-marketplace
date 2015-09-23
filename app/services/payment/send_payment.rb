class SendPayment
  include Interactor

  def call
    if context.is_payment_required == true
      puts "PAYMENT REQUIRED" # remove later, here for testing
      charge = context.charge
      # processor = PaymentFactory.new.build
      # payment = processor.send_charge(charge)
      # context.payment = payment
    else
      puts "NOOOOO PAYMENT REQUIRED" # remove later, here for testing
      return
    end
  end
end