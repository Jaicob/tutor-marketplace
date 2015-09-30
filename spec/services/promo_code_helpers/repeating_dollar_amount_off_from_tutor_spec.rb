require 'rails_helper'

RSpec.describe 'PromoCodeHelpers::RepeatingDollarAmountOffFromTutor' do
  let(:course) { create(:course) }
  let(:second_course) { create(:second_course) }



  describe 'Methods in PromoCodeServices::RepeatingDollarAmountOffFromTutor' do

    before :each do 
      @tutor = create(:tutor, :with_tutor_courses)
      course_id = @tutor.courses.first.id
      slot_id = @tutor.slots.create(start_time: "2015-09-01 10:00:00", duration: 21600).id
      @appointment = create(:appointment, slot_id: slot_id, course_id: course_id)
      @promotion = @tutor.promotions.create(code: '123', category: :repeating_dollar_amount_off_from_tutor, amount: 5, valid_from: Date.today, valid_until: Date.today + 30, redemption_limit: 5, redemption_count: 0, course_id: course_id)
      tutor_course = create(:tutor_course, tutor_id: @tutor.id, course_id: course_id )
    end

    it 'adjusts fees for a $5-off coupon issued by a Tutor for one eligible appt' do 
      @promotion.update(amount: 5)
      params = {
        tutor: @tutor,
        appointments: [@appointment],
        customer_id: 1,
        token: 1111111111,
        rates: [23],
        transaction_percentage: 15,
        promotion_id: @promotion.id,
        is_payment_required: true,
        promotion_category: nil
      }
      context = CreateCharge.call(params)
      @context = PromoCodeHelpers::RepeatingDollarAmountOffFromTutor.new(context)

      expect(@context.charge.amount).to eq 2645
      expect(@context.charge.tutor_fee).to eq 2300
      expect(@context.charge.axon_fee).to eq 345
      @context.return_adjusted_fees
      expect(@context.charge.amount).to eq 2070
      expect(@context.charge.tutor_fee).to eq 1800
      expect(@context.charge.axon_fee).to eq 270
    end

    it 'does not adjust fees for a $5-off coupon issued by a Tutor for a non-eligible appt' do 
      @promotion.update(amount: 5)
      @appointment.update(course_id: second_course.id)
      params = {
        tutor: @tutor,
        appointments: [@appointment],
        customer_id: 1,
        token: 1111111111,
        rates: [23],
        transaction_percentage: 15,
        promotion_id: @promotion.id,
        is_payment_required: true,
        promotion_category: nil
      }
      context = CreateCharge.call(params)
      @context = PromoCodeHelpers::RepeatingDollarAmountOffFromTutor.new(context)

      expect(@context.charge.amount).to eq 2645
      expect(@context.charge.tutor_fee).to eq 2300
      expect(@context.charge.axon_fee).to eq 345
      @context.return_adjusted_fees
      expect(@context.charge.amount).to eq 2645
      expect(@context.charge.tutor_fee).to eq 2300
      expect(@context.charge.axon_fee).to eq 345
    end

    # it 'correctly adjusts fees for a $10-off coupon issued by a Tutor' do 
    #   @promotion.update(amount: 10)
    #   params = {
    #     tutor: tutor,
    #     appointments: [appointment],
    #     customer_id: 1,
    #     token: 1111111111,
    #     rates: [23],
    #     transaction_percentage: 15,
    #     promotion_id: @promotion.id,
    #     is_payment_required: true,
    #     promotion_category: nil
    #   }
    #   context = CreateCharge.call(params)
    #   @context = PromoCodeHelpers::DollarAmountOffFromTutor.new(context)

    #   expect(@context.charge.amount).to eq 2645
    #   expect(@context.charge.tutor_fee).to eq 2300
    #   expect(@context.charge.axon_fee).to eq 345
    #   @context.return_adjusted_fees
    #   expect(@context.charge.amount).to eq 1495
    #   expect(@context.charge.tutor_fee).to eq 1300
    #   expect(@context.charge.axon_fee).to eq 195
    # end

    # it 'correctly adjusts fees for a $20-off coupon issued by a Tutor' do 
    #   @promotion.update(amount: 20)
    #   params = {
    #     tutor: tutor,
    #     appointments: [appointment],
    #     customer_id: 1,
    #     token: 1111111111,
    #     rates: [23],
    #     transaction_percentage: 15,
    #     promotion_id: @promotion.id,
    #     is_payment_required: true,
    #     promotion_category: nil
    #   }
    #   context = CreateCharge.call(params)
    #   @context = PromoCodeHelpers::DollarAmountOffFromTutor.new(context)

    #   expect(@context.charge.amount).to eq 2645
    #   expect(@context.charge.tutor_fee).to eq 2300
    #   expect(@context.charge.axon_fee).to eq 345
    #   @context.return_adjusted_fees
    #   expect(@context.charge.amount).to eq 345
    #   expect(@context.charge.tutor_fee).to eq 300
    #   expect(@context.charge.axon_fee).to eq 45
    # end

    # it 'increments the redemption_count for a promotion by 1 when succesfully applied' do
    #   params = {
    #     tutor: tutor,
    #     appointments: [appointment],
    #     customer_id: 1,
    #     token: 1111111111,
    #     rates: [23],
    #     transaction_percentage: 15,
    #     promotion_id: @promotion.id,
    #     is_payment_required: true,
    #     promotion_category: nil
    #   }
    #   context = CreateCharge.call(params)
    #   @context = PromoCodeHelpers::DollarAmountOffFromTutor.new(context)

    #   expect(@promotion.redemption_count).to eq 0
    #   @context.return_adjusted_fees
    #   expect(@promotion.reload.redemption_count).to eq 1
    # end

    # it 'does not give discount for promo_code if code is past redemption_limit' do 
    #   @promotion.update(redemption_limit: 100, redemption_count: 100)
    #   params = {
    #     tutor: tutor,
    #     appointments: [appointment],
    #     customer_id: 1,
    #     token: 1111111111,
    #     rates: [23],
    #     transaction_percentage: 15,
    #     promotion_id: @promotion.id,
    #     is_payment_required: true,
    #     promotion_category: nil
    #   }
    #   context = CreateCharge.call(params)
    #   @context = PromoCodeHelpers::DollarAmountOffFromTutor.new(context)

    #   expect(@context.charge.amount).to eq 2645
    #   expect(@context.charge.tutor_fee).to eq 2300
    #   expect(@context.charge.axon_fee).to eq 345
    #   @context.return_adjusted_fees
    #   expect(@context.charge.amount).to eq 2645
    #   expect(@context.charge.tutor_fee).to eq 2300
    #   expect(@context.charge.axon_fee).to eq 345
    # end

    #  it 'does not give discount for expired promo_code' do
    #   @promotion.update(valid_from: Date.today - 300, valid_until: Date.today - 299) 
    #   params = {
    #     tutor: tutor,
    #     appointments: [appointment],
    #     customer_id: 1,
    #     token: 1111111111,
    #     rates: [23],
    #     transaction_percentage: 15,
    #     promotion_id: @promotion.id,
    #     is_payment_required: true,
    #     promotion_category: nil
    #   }
    #   context = CreateCharge.call(params)
    #   @context = PromoCodeHelpers::DollarAmountOffFromTutor.new(context)

    #   expect(@context.charge.amount).to eq 2645
    #   expect(@context.charge.tutor_fee).to eq 2300
    #   expect(@context.charge.axon_fee).to eq 345
    #   @context.return_adjusted_fees
    #   expect(@context.charge.amount).to eq 2645
    #   expect(@context.charge.tutor_fee).to eq 2300
    #   expect(@context.charge.axon_fee).to eq 345
    # end

    # it 'does not give discount if tutor on promo_code and charge are not the same' do 
    #   @promotion.update(tutor_id: different_tutor.id) 
    #   params = {
    #     tutor: tutor,
    #     appointments: [appointment],
    #     customer_id: 1,
    #     token: 1111111111,
    #     rates: [23],
    #     transaction_percentage: 15,
    #     promotion_id: @promotion.id,
    #     is_payment_required: true,
    #     promotion_category: nil
    #   }
    #   context = CreateCharge.call(params)
    #   @context = PromoCodeHelpers::DollarAmountOffFromTutor.new(context)

    #   expect(@context.charge.amount).to eq 2645
    #   expect(@context.charge.tutor_fee).to eq 2300
    #   expect(@context.charge.axon_fee).to eq 345
    #   @context.return_adjusted_fees
    #   expect(@context.charge.amount).to eq 2645
    #   expect(@context.charge.tutor_fee).to eq 2300
    #   expect(@context.charge.axon_fee).to eq 345
    # end

  end
end