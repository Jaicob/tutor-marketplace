class SendPayment
  include Interactor

  def call
    begin 
      if context.is_payment_required != false && context.charge.amount > 0
        processor = PaymentFactory.new.build
        stripe_charge_object = processor.send_charge(context.charge)
        context.charge.update(stripe_charge_id: stripe_charge_object.id)
      else
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