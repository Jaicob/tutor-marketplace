class ReconcileCouponDifference
  include Interactor

  # Call with tutor:  Instance of Tutor
  #           amount: Difference in cents between normal and discounted price
  #           promo:  Instance of Promotion used in discount

  def call
    processor = PaymentFactory.new.build
    payment = processor.send_charge(context.charge)
    puts "ZZZZZZ Discount price = #{context.charge.amount}"
    puts "ZZZZZZ Axon fee = #{context.charge.axon_fee}"
    puts "ZZZZZZ Tutor fee = #{context.charge.tutor_fee}"
    puts "ZZZZZZ Axon owes tutor = #{context.axon_owes_tutor}"

    # promotion_description = Promotion.find(context.promotion_id).description
    # puts "PROMO DESC = #{promotion_description}"
    # tutor_account_id = context.tutor.acct_id
    # puts "TTTTTTUTOR = #{context.tutor}"
    # puts "TUTOR ACCT = #{tutor_account_id}"
    # amount = context.charge.amount
    # puts "AMOUNT = #{context.charge.amount}"
    context.response = processor.reconcile_coupon_difference(context.charge)
  end
end