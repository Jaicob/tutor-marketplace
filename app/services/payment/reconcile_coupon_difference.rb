class ReconcileCouponDifference
  include Interactor

  # Call with tutor:  Instance of Tutor
  #           transfer_amount: Difference in cents between normal and discounted price
  #           promo:  Instance of Promotion used in discount

  def call
    begin 
      # This is only called when axon_fee is less than 0 which means that the amount paid by a student does not cover the tutor's set fee, leaving no fee for Axon, which in effect means that Axon needs to pay a tutor a portion of their set fee for the tutor to recieve full payment. This happens as a result of a free or discounted session promo code that is issued by Axon - as opposed to a discount promo offered by a tutor which Axon has no financial responsibility for.
      if context.charge.axon_fee < 0
        processor = PaymentFactory.new.build
        tutor = context.charge.tutor
        puts "context.charge.axon_fee = #{context.charge.axon_fee}"
        puts "context.charge.axon_fee.abs = #{context.charge.axon_fee.abs}"
        puts "context.charge.axon_fee.abs.class = #{context.charge.axon_fee.abs.class}"
        puts "context.charge.axon_fee.abs.to_i = #{context.charge.axon_fee.abs.to_i}"
        transfer_amount = context.charge.axon_fee.abs
        promotion = Promotion.find(context.promotion_id)
        processor.reconcile_coupon_difference(tutor, transfer_amount, promotion)
      end
    rescue => error
      context.fail!(
        error: error,
        failed_interactor: self.class
      )
    end
  end
end