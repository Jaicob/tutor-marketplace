class SendPayment
  include Interactor

  def call
    begin 
      if context.charge.amount > 0
        processor = PaymentFactory.new.build
        @stripe_create_charge_response = processor.send_charge(context.charge)
        context.charge.update(stripe_charge_id: @stripe_create_charge_response.id)  
      else
        puts "No payment necessary"
        return
      end
    rescue => error
      context.fail!(
        error: @stripe_create_charge_response.message,
        failed_interactor: self.class
      )
    end
  end
  
end