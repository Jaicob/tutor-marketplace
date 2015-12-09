require 'rails_helper'

RSpec.describe 'PromoCodeHelpers::DollarAmountOffFromTutor' do
  
  # Runs once before all examples
  before(:context) do
    @tutor = create(:tutor, :with_tutor_course_and_slot)
    @tutor_course = @tutor.tutor_courses.first
    @student = create(:student)
  end

  describe 'Dollar Amount Off From Tutor Promos' do

    before :each do 
      @promotion = create(:promotion, category: :dollar_amount_off_from_tutor, tutor_id: @tutor.id)
    end

    it 'correctly adjusts fees for a $5-off coupon issued by a Tutor' do 
      @promotion.update(amount: 5)
      params = {
        tutor_id: @tutor.id,
        student_id: @student.id,
        stripe_token: @token,
        appts_info: [{slot_id: @tutor.slots.first.id, course_id: @tutor.courses.first.id, start_time: @tutor.slots.first.start_time}],
        promotion_id: @promotion.id
      }
      context = CreateAppointments.call(params)
      context = CreateCharge.call(context)
      promo_helper = PromoCodeHelpers::DollarAmountOffFromTutor.new(context)

      expect(promo_helper.charge.amount).to eq 2300
      expect(promo_helper.charge.tutor_fee).to eq 2000
      expect(promo_helper.charge.axon_fee).to eq 300
      promo_helper.return_adjusted_fees
      expect(promo_helper.charge.amount).to eq 1725
      expect(promo_helper.charge.tutor_fee).to eq 1500
      expect(promo_helper.charge.axon_fee).to eq 225
    end

    it 'correctly adjusts fees for a $10-off coupon issued by a Tutor' do 
      @promotion.update(amount: 10)
      params = {
        tutor_id: @tutor.id,
        student_id: @student.id,
        stripe_token: @token,
        appts_info: [{slot_id: @tutor.slots.first.id, course_id: @tutor.courses.first.id, start_time: @tutor.slots.first.start_time}],
        promotion_id: @promotion.id
      }
      context = CreateAppointments.call(params)
      context = CreateCharge.call(context)
      promo_helper = PromoCodeHelpers::DollarAmountOffFromTutor.new(context)

      expect(promo_helper.charge.amount).to eq 2300
      expect(promo_helper.charge.tutor_fee).to eq 2000
      expect(promo_helper.charge.axon_fee).to eq 300
      promo_helper.return_adjusted_fees
      expect(promo_helper.charge.amount).to eq 1150
      expect(promo_helper.charge.tutor_fee).to eq 1000
      expect(promo_helper.charge.axon_fee).to eq 150
    end

    it 'correctly adjusts fees for a $20-off coupon issued by a Tutor' do 
      @promotion.update(amount: 20)
      params = {
        tutor_id: @tutor.id,
        student_id: @student.id,
        stripe_token: @token,
        appts_info: [{slot_id: @tutor.slots.first.id, course_id: @tutor.courses.first.id, start_time: @tutor.slots.first.start_time}],
        promotion_id: @promotion.id
      }
      context = CreateAppointments.call(params)
      context = CreateCharge.call(context)
      promo_helper = PromoCodeHelpers::DollarAmountOffFromTutor.new(context)

      expect(promo_helper.charge.amount).to eq 2300
      expect(promo_helper.charge.tutor_fee).to eq 2000
      expect(promo_helper.charge.axon_fee).to eq 300
      promo_helper.return_adjusted_fees
      expect(promo_helper.charge.amount).to eq 0
      expect(promo_helper.charge.tutor_fee).to eq 0
      expect(promo_helper.charge.axon_fee).to eq 0
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
      promo_helper = PromoCodeHelpers::DollarAmountOffFromTutor.new(context)

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
      promo_helper = PromoCodeHelpers::DollarAmountOffFromTutor.new(context)

      expect(promo_helper.charge.amount).to eq 2300
      expect(promo_helper.charge.tutor_fee).to eq 2000
      expect(promo_helper.charge.axon_fee).to eq 300
      promo_helper.return_adjusted_fees
      expect(promo_helper.charge.amount).to eq 2300
      expect(promo_helper.charge.tutor_fee).to eq 2000
      expect(promo_helper.charge.axon_fee).to eq 300
    end

     it 'does not give discount for expired promo_code' do
      @promotion.update(valid_from: Date.today - 300, valid_until: Date.today - 299) 
      params = {
        tutor_id: @tutor.id,
        student_id: @student.id,
        stripe_token: @token,
        appts_info: [{slot_id: @tutor.slots.first.id, course_id: @tutor.courses.first.id, start_time: @tutor.slots.first.start_time}],
        promotion_id: @promotion.id
      }
      context = CreateAppointments.call(params)
      context = CreateCharge.call(context)
      promo_helper = PromoCodeHelpers::DollarAmountOffFromTutor.new(context)

      expect(promo_helper.charge.amount).to eq 2300
      expect(promo_helper.charge.tutor_fee).to eq 2000
      expect(promo_helper.charge.axon_fee).to eq 300
      promo_helper.return_adjusted_fees
      expect(promo_helper.charge.amount).to eq 2300
      expect(promo_helper.charge.tutor_fee).to eq 2000
      expect(promo_helper.charge.axon_fee).to eq 300
    end

    it 'does not give discount if tutor on promo_code and charge are not the same' do 
      @promotion.update(tutor_id: 0) 
      params = {
        tutor_id: @tutor.id,
        student_id: @student.id,
        stripe_token: @token,
        appts_info: [{slot_id: @tutor.slots.first.id, course_id: @tutor.courses.first.id, start_time: @tutor.slots.first.start_time}],
        promotion_id: @promotion.id
      }
      context = CreateAppointments.call(params)
      context = CreateCharge.call(context)
      promo_helper = PromoCodeHelpers::DollarAmountOffFromTutor.new(context)

      expect(promo_helper.charge.amount).to eq 2300
      expect(promo_helper.charge.tutor_fee).to eq 2000
      expect(promo_helper.charge.axon_fee).to eq 300
      promo_helper.return_adjusted_fees
      expect(promo_helper.charge.amount).to eq 2300
      expect(promo_helper.charge.tutor_fee).to eq 2000
      expect(promo_helper.charge.axon_fee).to eq 300
    end

  end
end