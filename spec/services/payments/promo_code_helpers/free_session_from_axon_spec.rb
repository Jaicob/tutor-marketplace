require 'rails_helper'

RSpec.describe 'PromoCodeHelpers::FreeSessionFromAxon' do

  # Runs once before all examples
  before(:context) do
    @tutor = create(:tutor, :with_tutor_course_and_slot)
    @tutor_course = @tutor.tutor_courses.first
    @student = create(:student)
  end

  describe 'Free Session From Axon Promos' do

    before(:each) do 
      @promotion = create(:promotion, category: :free_from_axon, amount: 1)
    end
  
    it 'adjusts fees for a free_session coupon issued by Axon' do 
      params = {
        tutor_id: @tutor.id,
        student_id: @student.id,
        stripe_token: @token,
        appts_info: [{slot_id: @tutor.slots.first.id, course_id: @tutor.courses.first.id, start_time: @tutor.slots.first.start_time}],
        promotion_id: @promotion.id
      }
      context = CreateAppointments.call(params)
      context = CreateCharge.call(context)
      promo_helper = PromoCodeHelpers::FreeSessionFromAxon.new(context)

      expect(promo_helper.charge.amount).to eq 2300
      expect(promo_helper.charge.tutor_fee).to eq 2000
      expect(promo_helper.charge.axon_fee).to eq 300
      promo_helper.return_adjusted_fees
      expect(promo_helper.charge.amount).to eq 0
      expect(promo_helper.charge.tutor_fee).to eq 2000
      expect(promo_helper.charge.axon_fee).to eq -2000
    end

    it 'only gives one free session (the cheapest one) in a booking with multiple appointments' do 
      params = {
        tutor_id: @tutor.id,
        student_id: @student.id,
        stripe_token: @token,
        appts_info: [
          {slot_id: @tutor.slots.first.id, course_id: @tutor.courses.first.id, start_time: @tutor.slots.first.start_time},
          {slot_id: @tutor.slots.first.id, course_id: @tutor.courses.first.id, start_time: @tutor.slots.first.start_time.to_date.to_s + " 13:00"}
        ],
        promotion_id: @promotion.id
      }
      context = CreateAppointments.call(params)
      context = CreateCharge.call(context)
      promo_helper = PromoCodeHelpers::FreeSessionFromAxon.new(context)

      expect(promo_helper.charge.amount).to eq 4600
      expect(promo_helper.charge.tutor_fee).to eq 4000
      expect(promo_helper.charge.axon_fee).to eq 600
      promo_helper.return_adjusted_fees
      expect(promo_helper.charge.amount).to eq 2300
      expect(promo_helper.charge.tutor_fee).to eq 4000
      expect(promo_helper.charge.axon_fee).to eq -1700
    end

    it 'increments the redemption_count for a promotion by 1 when succesfully applied' do
      params = {
        tutor_id: @tutor.id,
        student_id: @student.id,
        stripe_token: @token,
        appts_info: [{slot_id: @tutor.slots.first.id, course_id: @tutor.courses.first.id, start_time: @tutor.slots.first.start_time}],
        promotion_id: @promotion.id
      }
      context = CreateAppointments.call(params)
      context = CreateCharge.call(context)
      promo_helper = PromoCodeHelpers::FreeSessionFromAxon.new(context)

      expect(@promotion.redemption_count).to eq 0
      promo_helper.return_adjusted_fees
      expect(@promotion.reload.redemption_count).to eq 1
    end

    it 'does not give discount for promo_code if code is past redemption_limit' do 
      @promotion.update(redemption_limit: 1, redemption_count: 1)
      params = {
        tutor_id: @tutor.id,
        student_id: @student.id,
        stripe_token: @token,
        appts_info: [{slot_id: @tutor.slots.first.id, course_id: @tutor.courses.first.id, start_time: @tutor.slots.first.start_time}],
        promotion_id: @promotion.id
      }
      context = CreateAppointments.call(params)
      context = CreateCharge.call(context)
      promo_helper = PromoCodeHelpers::FreeSessionFromAxon.new(context)

      expect(promo_helper.charge.amount).to eq 2300
      expect(promo_helper.charge.tutor_fee).to eq 2000
      expect(promo_helper.charge.axon_fee).to eq 300
      promo_helper.return_adjusted_fees
      expect(promo_helper.charge.amount).to eq 2300
      expect(promo_helper.charge.tutor_fee).to eq 2000
      expect(promo_helper.charge.axon_fee).to eq 300
    end

    it 'does not give discount for expired promo_code' do
      @promotion.update(valid_from: Date.today - 10, valid_until: Date.today - 1) 
      params = {
        tutor_id: @tutor.id,
        student_id: @student.id,
        stripe_token: @token,
        appts_info: [{slot_id: @tutor.slots.first.id, course_id: @tutor.courses.first.id, start_time: @tutor.slots.first.start_time}],
        promotion_id: @promotion.id
      }
      context = CreateAppointments.call(params)
      context = CreateCharge.call(context)
      promo_helper = PromoCodeHelpers::FreeSessionFromAxon.new(context)

      expect(promo_helper.charge.amount).to eq 2300
      expect(promo_helper.charge.tutor_fee).to eq 2000
      expect(promo_helper.charge.axon_fee).to eq 300
      promo_helper.return_adjusted_fees
      expect(promo_helper.charge.amount).to eq 2300
      expect(promo_helper.charge.tutor_fee).to eq 2000
      expect(promo_helper.charge.axon_fee).to eq 300
    end

    it 'is_payment_required is false with valid free session code on booking with only one session' do 
      params = {
        tutor_id: @tutor.id,
        student_id: @student.id,
        stripe_token: @token,
        appts_info: [{slot_id: @tutor.slots.first.id, course_id: @tutor.courses.first.id, start_time: @tutor.slots.first.start_time}],
        promotion_id: @promotion.id
      }
      context = CreateAppointments.call(params)
      context = CreateCharge.call(context)
      expect(context.is_payment_required).to eq(true)

      @context = ApplyPromoCode.call(context)
      expect(@context.is_payment_required).to eq(false)
    end

    it 'is_payment_required is true with valid free session code on booking with more than one session' do 
      params = {
        tutor_id: @tutor.id,
        student_id: @student.id,
        stripe_token: @token,
        appts_info: [
          {slot_id: @tutor.slots.first.id, course_id: @tutor.courses.first.id, start_time: @tutor.slots.first.start_time},
          {slot_id: @tutor.slots.first.id, course_id: @tutor.courses.first.id, start_time: @tutor.slots.first.start_time.to_date.to_s + " 13:00"}
        ],
        promotion_id: @promotion.id
      }
      context = CreateAppointments.call(params)
      context = CreateCharge.call(context)
      expect(context.is_payment_required).to eq(true)

      @context = ApplyPromoCode.call(context)
      expect(@context.is_payment_required).to eq(true)
    end

  end
end