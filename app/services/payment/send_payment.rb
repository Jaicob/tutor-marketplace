class SendPayment
  include Interactor

  def call
    begin 
      if context.is_payment_required != false && context.charge.amount > 0
        charge = context.charge
        processor = PaymentFactory.new.build
        payment = processor.send_charge(charge)
        context.payment = payment
        puts "CALLED IF"
      else
        puts "CALLED ELSE"
        return
      end
    rescue => error
      context.fail!(
        error: error,
        failed_interactor: self.class
      )
    end
  end
  
end