class SendPayment
  include Interactor

  def call
    begin 
      charge = context.charge

      if charge.axon_fee < 0
        context.tutor_compensation_by_axon_required = true
        context.tutor_compensation_amount = charge.axon_fee.abs
        charge.update(axon_fee: 0) 
      end
      
      if context.charge.amount > 0
        processor = PaymentFactory.new.build
        @stripe_create_charge_response = processor.send_charge(charge, context.charge_description, context.one_time_card)
        context.charge.update(stripe_charge_id: @stripe_create_charge_response.id)  
      else
        puts "No payment necessary"
        return
      end
      
    rescue => error
      context.fail!(
        # error: 'go fuck yourself',
        error: @stripe_create_charge_response.message,
        failed_interactor: self.class
      )
    end
  end

end