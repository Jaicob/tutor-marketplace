class ApplyPromoCode
  include Interactor

  before do
    # this determines the type of a promo code (if one exists) and calls the appropriate method to evaluate that promo code category
    if context.promotion_id != nil
      @promotion = Promotion.find(context.promotion_id)
      promo_category = @promotion.category
      case promo_category
      when 'free_from_axon'
        @method = apply_free_axon_session_promo
      when 'free_from_tutor'
        @method = apply_free_tutor_session_promo
      when 'dollar_amount_off'
        @method = apply_dollar_amount_off_promo
      when 'percent_off'
        @method = apply_percentage_off_promo
      when 'semester_package'
        @method = apply_semester_package_promo
      end
    else
      @method = nil
    end
  end

  def call
    @method
  end
  
  private

    def apply_free_axon_session_promo
      context.charge.update(promotion_id: context.promotion_id)
      context.is_payment_required = false
      # amount should equal 0
      # transaction_fee should equal 0
    end

    def apply_free_tutor_session_promo
      context.charge.update(promotion_id: context.promotion_id)
      context.is_payment_required = false
    end

    def apply_dollar_amount_off_promo
      # can subtract directly from the total price
      context.charge.update(promotion_id: context.promotion_id)
      context.is_payment_required = true

      puts "Original total amount = #{context.charge.amount}"
      puts "Original Axon Fee = #{context.charge.axon_fee}"
      puts "Original Tutor Fee = #{context.charge.tutor_fee}"

      promotion = Promotion.find(context.promotion_id)
      promotion_discount = promotion.amount * 100
      puts "Promotion value = #{promotion_discount}"

      # decrease amount by promotion discount
      context.charge.amount = context.charge.amount - promotion_discount

      puts "Discounted amount = #{context.charge.amount}"
      puts "Tutor fee = #{context.charge.tutor_fee}"

      axon_owes_tutor = context.charge.tutor_fee - context.charge.amount
      puts "Axon owes tutor = #{axon_owes_tutor}"
      # now we know how much a tutor is owed, and how much, if any, axon needs to pay the tutor to make up the rest of the tutor's fee
      # what next?
      # if 

      if axon_owes_tutor > 0
        context.charge.axon_fee = 0
        context.charge.tutor_fee = context.charge.amount
      end

      puts "Discount price = #{context.charge.amount}"
      puts "Axon fee = #{context.charge.axon_fee}"
      puts "Tutor fee = #{context.charge.tutor_fee}"
      puts "Axon owes tutor = #{axon_owes_tutor}"

      context.axon_owes_tutor = axon_owes_tutor

      ReconcileCouponDifference.call(context)

      # puts "Appointments = #{context.appointments}"
      # puts "Transaction fee = #{context.charge.transaction_fee}"

      # transaction_fee = context.charge.transaction_fee
      # amount = context.charge.amount + context.charge.transaction_fee
    end

    #<Charge id: 61, amount: 6462, transaction_fee: 962, customer_id: "1", tutor_id: 1, token: "789867877868", created_at: "2015-09-22 22:01:42", updated_at: "2015-09-22 22:01:42", promotion_id: 1>

    def apply_percentage_off_promo
      # will have to single out an indivudal appointment (or at least an indivudal appt's price)
      context.charge.update(promotion_id: context.promotion_id)
      context.is_payment_required = true
    end

    def apply_semester_package_promo
      context.charge.update(promotion_id: context.promotion_id)
      context.is_payment_required = false
    end

end

    # charge = context.tutor.charges.create(token: context.token, customer_id: context.customer_id,
    #                                       amount: amount, transaction_fee: transaction_fee)

# => {:tutor=>#
#     <Tutor id: 1, user_id: 1, active_status: 0, application_status: 0, rating: 5, degree: "B.A.", major: "Marine Biology", extra_info: "Doloribus accusamus non hic.", graduation_year: "2018", phone_number: "3067832947", birthdate: "1990-01-01", profile_pic: nil, transcript: "file-icon.png", appt_notes: nil, created_at: "2015-09-21 21:08:15", updated_at: "2015-09-21 21:08:15", last_4_acct: nil, line1: nil, line2: nil, city: nil, state: nil, postal_code: nil, ssn_last_4: nil, acct_id: nil>, 
#   :appointments=>
#     [#<Appointment id: 1, student_id: 5, slot_id: 73, course_id: 1, start_time: "2015-08-01 12:00:00", status: 0, created_at: "2015-09-21 21:08:37", updated_at: "2015-09-23 12:36:57", charge_id: 62>, #<Appointment id: 2, student_id: 4, slot_id: 55, course_id: 1, start_time: "2015-08-01 12:00:00", status: 0, created_at: "2015-09-21 21:08:37", updated_at: "2015-09-23 12:36:57", charge_id: 62>], 
#   :customer_id=>1, 
#   :token=>789867877868, 
#   :rates=>[30, 25]
#   :transaction_percentage=>17.5, 
#   :promotion_id=>1, 
#   :is_payment_required=>true}

params = {
  tutor: Tutor.first,
  appointments: [Appointment.first, Appointment.second],
  customer_id: 1,
  token: 789867877868,
  rates: [30, 25],
  transaction_percentage: 15.0,
  promotion_id: 1,
  is_payment_required: true,
}
